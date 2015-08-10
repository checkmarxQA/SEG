package com.accor.asa.commun.services.mail.poolthread;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Ce pool de thread � quelques particularit� en comparaison avec un ThreadPoolExecutor :
 * <li> Il est posible de le mettre en pause (les thread seront quand m�me instanci� avec les mails donn�s au pool de thread jusqu'a concurence du maximum autoris� mais il ne se lanceront pas, les autres mails arrivant dans le pool seront empil�s dans la queue)
 * <li> Il surveille la taille de la queue et garde en m�moire la taille maximum et l'instant auquel cela s'est produit
 * <li> Il a un etat ExecutorState qui peut etre soit running, paused, in shutdown, teminated, ... etc
 * <li> Il a une proc�dure de shutdown qui mets � jour l'�tat avec l'ExecutorState ad�quat
 * <li> Il poss�de un mode debug
 * <li> Il surveille la taille des mail en mode debug
 * <li> Il peut service de garant de la taille maximum de la queue via la methode isFull qui se base sur la propri�t� maxCapacity
 * <li> Il garde en m�moire l'heure de son d�marrage et peut donner le laps de temps qui s'est �coul� depuis
 * Created by IntelliJ IDEA.
 * User: dgonneau
 * Date: 2 f�vr. 2006
 * Time: 11:14:27
 * To change this template use File | Settings | File Templates.
 */
public class PausableThreadPoolExecutor extends ThreadPoolExecutor {
   private boolean _isPaused;
   private Date _dateLaunched;
   private int _nbMaxInQueue;
   private Date _dateWasAtMaxInQueue;
   private ReentrantLock _pauseLock = new ReentrantLock();
   private Condition _unpaused = _pauseLock.newCondition();
   private ExecutorState _state;
   private int _waitShutdown;
   private SimpleDateFormat _dateFormat;
   private int _maxCapacity;
   private int _biggestMailSize;
   private boolean _debug;


   /**
    * Override du contructeur de la classe super
    * on initialise quelques donn�es qui sont sp�cifiques � la classe PausableThreadPoolExecutor
    * @param corePoolSize : taille du code de thread
    * @param maximumPoolSize : nombre de thread total maximum
    * @param keepAliveTime : keepalive time des thread cr��s en sus du code
    * @param unit : Time unit du keepAliveTime
    * @param workQueue : workingQueue associ�e � l'executor
    * @param maxCapacity : capacit� maximale de la queue, g�r�e programaticalement
    * @param waitShutdown : temps en seconde d'attente pour un clean shutdown
    * @param debug : indique que le pool de thread est en mode debug, influe sur le travail effectu� par le beforeExectute
    */
   public PausableThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue workQueue,int maxCapacity,int waitShutdown, boolean debug) {
      super(corePoolSize,maximumPoolSize,keepAliveTime,unit,workQueue);
      _dateLaunched = new Date();
      _nbMaxInQueue = 0;
      _maxCapacity = maxCapacity;
      _waitShutdown = waitShutdown;
      _state = ExecutorState.RUNNING;
      _dateFormat = new SimpleDateFormat("EEEE dd/MM/yyyy 'a' HH:mm:ss");
      _debug = debug;
   }

   /**
    * override du beforeExecute qui g�re la mise en pause
    * surveille �galement les tailles de mails si en mode debug
    * surveille �galement la taille de la queue
    * @param t
    * @param r
    */
   protected void beforeExecute(Thread t, Runnable r) {
     super.beforeExecute(t, r);
     _pauseLock.lock();
     try {
       while (_isPaused) _unpaused.await();
     } catch (InterruptedException ie) {
       t.interrupt();
     } finally {
       _pauseLock.unlock();
     }
      int current_size = super.getQueue().size();
      if (current_size>_nbMaxInQueue){
         _nbMaxInQueue=current_size;
         _dateWasAtMaxInQueue = new Date();
      }
      int current_mailsize;
      if (_debug) {
         current_mailsize = ((MailSenderTask)r).getMail().getMemorySize();
         if (current_mailsize > _biggestMailSize){
            _biggestMailSize =  current_mailsize;
         }
      }
   }

   /**
    * permet de savoir si le queue est full par programmation dans le cas ou on utilise une queue non bound�e (oh le bel anglicisme)
    * @return true si la queue est �gale ou sup�rieur � la maxCapacity
    */
   public boolean isFull(){
      return super.getQueue().size() >= _maxCapacity;
   }

   /**
    * permet de changer "� chaud" la capacit� maximal de la queue
    * @param capacity : la capacit� maximale de la queue du pool de thread
    */
   public void setMaxCapacity(int capacity){
      _maxCapacity = capacity;
   }

   /**
    * permet de r�cup�rer la capacit� maximum que peut prendre la queue
    * � utiliser avec isFull en dehors de cette classe pour ne pas envoyer de mails si isFull = true
    * @return la capacit� maximum
    */
   public int getMaxCapacity(){
      return _maxCapacity;
   }

   /**
    * indique si l'executor est en pause
    * @return true si en pause
    */
   public boolean isPaused(){
      return _isPaused;
   }

   /**
    * indique si l'executor est en fonctionnement normal
    * @return  true si pas en pause
    */
   public boolean isRunning(){
      return !_isPaused;
   }

   /**
    * permet de retrouver la date � laquelle le Pool de thread � �t� instanci�
    * @return  la date de d'instanciation
    */
   public String getDateLaunched(){
      try{
         if (_dateLaunched==null) return "Pas encore demarre";
         return _dateFormat.format(_dateLaunched);
      } catch (Exception e){
         return "Pas encore demarre";
      }
   }

   /**
    * permet de retrouver le nombre maximum qui a �t� vu dans la queue depuis le d�marrage du pool
    * @return  le max de la queue
    */
   public int getNbMaxInQueue(){
      return _nbMaxInQueue;
   }

   /**
    * Permet de retrouver la plus grande taille de mail d�tect�e en mode DEBUG
    * @return la taille maximum d�tect�e
    */
   public int getBiggestMailSize(){
      return _biggestMailSize;
   }

   /**
    * Permet de retrouver le temps, en secondes, pendant lequel on attend la compl�tion du clean shutdown
    * @return le temps en secondes
    */
   public int getWaitShutdown(){
      return _waitShutdown;
   }

   /**
    * Permet de modifier "� chaud" le temps d'attente pour un clean shutdown
    * @param waitShutdown
    */
   public void setWaitShutdown(int waitShutdown){
      _waitShutdown = waitShutdown;
   }

   /**
    * Renvoie la date � laquelle la queue � �t� la plus remplie
    * @return la date format�e en EEEE dd/MM/yyyy '&agrave;' HH:mm:ss
    */
   public String getDateWasAtMaxInQueue(){
      try {
         if (_dateWasAtMaxInQueue==null)
            return "Info indisponible";
         else
            return _dateFormat.format(_dateWasAtMaxInQueue);
      } catch (Exception e){
         return "Info indisponible";
      }
   }

   /**
    * r�cup�re la dur�e d'execution du pool de thread en millisecondes
    * @return le temps en millisecondes
    */
   public long getTimeElapsed(){
      try {
         if(_dateLaunched==null) return 0;
         else return (new Date().getTime())-_dateLaunched.getTime();
      } catch (Exception ex) {
         return 0;
      }
   }

   /**
    * Permet de r�cuperer sous forme format�e la dur�e d'execution du pool
    * Possiblit� d'avoir une version courte : "3 jours, 12h45h12s"
    * ou longue : "3 jours, 12 heures, 45 minutes, 12 secondes"
    * @param shortVersion : passer true si on veut la version courte
    * @return la dur�e format�e
    */
   public String getTimeElapsedString(boolean shortVersion){
      try {
         long time = getTimeElapsed();
         if (time==0) return "Pas encore demarre";
         long days = Math.abs(time/1000/3600/24);
         time-=days*1000*3600*24;
         long hours = Math.abs(time/1000/3600);
         time-=hours*1000*3600;
         long minutes = Math.abs(time/1000/60);
         time-=minutes*1000*60;
         long seconds = Math.abs(time/1000);
         StringBuffer result = new StringBuffer();
         if (days>0) result.append(days).append(" jours, ");

         if (shortVersion){
            if (hours>0) result.append(hours).append("h");
            if (minutes>0) result.append(minutes).append("m");
            if (seconds>0) result.append(seconds).append("s");
         } else {
            if (hours>0) result.append(hours).append(" heures, ");
            if (minutes>0) result.append(minutes).append(" minutes, ");
            if (seconds>0) result.append(seconds).append(" secondes");
         }

         return result.toString();
      } catch (Exception ex) {
         return "Erreur de calcul !";
      }
   }

   /**
    * Calcul le nombre de mail par heure, ou une extrapolation de ce nombre si le pool n'est pas encore d�mar� depuis 1 heure
    * @return le nombre de mail par heure
    */
   public long getNbMailPerHours(){
      try {
         if (getTimeElapsed()==0 || getTaskCount()==0)
            return 0;
         else
            return Math.abs((60*60*1000*getTaskCount())/getTimeElapsed());
      } catch (Exception ex){
         return 0;
      }
   }

   /**
    * Permet de retrouver l'�tat ExecutorState actuel du Pool de thread
    * @return l'�tat ExecutorState actuel
    */
   public ExecutorState getState(){
      return _state;
   }

   /**
    * Permet de retrouver le libell� de l'�tat ExecutorState actuel du Pool de thread
    * @return libell� de l'�tat ExecutorState actuel
    */
   public String getStateLabel(){
      return _state.toString();
   }

   /**
    * Mets en pause le pool de thread
    * En pause, on continue d'instancier des thread tant que l'on a pas atteint le nombre max,
    * mais ces thread attendront que la pause soit enlev�e pour lancer l'envoi mail
    */
   public void pause() {
     _pauseLock.lock();
     try {
       _isPaused = true;
     } finally {
       _pauseLock.unlock();
     }
     _state = ExecutorState.PAUSED;
   }

   /**
    * Enl�ve la pause
    */
   public void resume() {
     _pauseLock.lock();
     try {
       _isPaused = false;
       _unpaused.signalAll();
     } finally {
       _pauseLock.unlock();
     }
     _state = ExecutorState.RUNNING;
   }

   /**
    * Permet de savoir si on est en mode debug
    * @return true si on est en mode debug
    */
   public boolean isDebugEnabled(){
      return _debug;
   }

   /**
    * Permet de forcer le mode Debug (normalement lu dans le mail.properties)
    * @param debugMode : boolean, true si on veut activer le mode debug, false si on veut le d�sactiver
    */
   public void setDebug(boolean debugMode){
      _debug = debugMode;
   }
   /**
    * l'int�ret de cette m�thode est peut �tre limit�,
    * voir nul si elle bloque un thread weblogique
    * voir a utiliser des objets condition
    */
   public void shutdownAndUpdateState() {
      shutdown();
      _state = ExecutorState.SHUTDOWN_IN_PROGRESS;
      if (_waitShutdown<=0) _waitShutdown=10;
      try {
         awaitTermination(_waitShutdown,TimeUnit.SECONDS);
      } catch (InterruptedException ex) {
         // l'attente a �t� interompue ...
      }
      if (!isShutdown()) return;
      // si l'executor � �t� jusqu'au bout de son shutdown, il sera soit terminating ou terminated
      // si il reste dans l'�tat terminating cela veut dire que des taches n'ont pas r�pondu au thread.interrupt
      // l'executor est donc dans un �tat pas propre ...
      if (isTerminating()) _state=ExecutorState.TERMINATING;
      if (isTerminated()) _state=ExecutorState.TERMINATED;
   }


 }