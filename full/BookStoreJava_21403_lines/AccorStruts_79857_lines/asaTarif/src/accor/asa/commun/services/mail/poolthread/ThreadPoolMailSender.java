package com.accor.asa.commun.services.mail.poolthread;

import java.util.concurrent.PriorityBlockingQueue;
import java.util.concurrent.RejectedExecutionException;
import java.util.concurrent.TimeUnit;

import com.accor.asa.commun.log.LogCommun;
import com.accor.asa.commun.services.mail.Email;
import com.accor.asa.commun.services.mail.MailException;
import com.accor.asa.commun.services.mail.MailSender;
import com.accor.asa.commun.utiles.FilesPropertiesCache;

/**
 * Factory impl�mentant l'interface MailSender et qui permet d'envoyer des mails via un pool de thread
 * Cette classe et les autres classes du package services.mail.poolthread sont normalement pr�tes pour le JDK 1.5
 * il suffira alors de remplacer import java.util.concurrent.* par import java.util.concurrent.*
 * User: dgonneau
 * Date: 31 janv. 2006
 * Time: 16:13:11
 */
public class ThreadPoolMailSender implements MailSender {

   private static PausableThreadPoolExecutor executor;
   private static PriorityBlockingQueue taskQueue;

   static {
      initThreadPool();
   }

   /**
    * V�rifie que l'executor est dans un etat correct
    * @return true si l'executor �tait dans un etat correct, false sinon
    */
   public static boolean runAvailabilityGuardian(){
      if (executor==null || executor.isTerminated() || executor.isShutdown() || executor.isTerminated()){
         initThreadPool();
         return false;
      } else return true;
   }

   /**
    * permet de r�cup�rer l'executor actuel pour debug or pour agir directement dessus
    * @return le PausableThreadPoolExecutor actuellement instanci�
    */
   public static PausableThreadPoolExecutor getExecutor(){
      runAvailabilityGuardian();
      return executor;
   }

   /**
    * permet de r�cup�rer la queue de l'executor
    * @return la priorityBlockingQueue actuellement instanci�e
    */
   public synchronized static PriorityBlockingQueue getQueue(){
      runAvailabilityGuardian();
      return taskQueue;
   }

   /**
    * permet de r�cup�rer la taille de la queueu de l'executor
    * @return  la taille de la queue
    */
   public static int getQueueSize(){
      runAvailabilityGuardian();
      return taskQueue.size();
   }

   /**
    * Permet de r�cup�rer un libell� explicite donnant le keepalive time
    * si keepalive time est au max, alors on dit qu'il n'y a pas de limite...
    * @return le libell�
    */
   public static String getKeepAliveTimeString(){
      long l = executor.getKeepAliveTime(TimeUnit.SECONDS);
      if (l==9223372036L)
         return "Pas de limite";
      else return String.valueOf(l)+" secondes";
   }

   /**
    * Initialise une nouvelle instance de PausableThreadPoolExecutor et de PriorityBlockingQueue
    * en se basant sur les param�tres du fichier mail.properties
    */
   private static void initThreadPool(){
      // lecture du fichier de properties
      LogCommun.debug("ThreadPoolMailSender","initThreadPool","init thread pool");
      int maxQueue,nbCoreThread,nbMaxThread,waitShutdown;
      boolean debug;
      long keepAliveTime;

      try {
         FilesPropertiesCache.getInstance().reloadProperties("mail");
         maxQueue = Integer.parseInt(FilesPropertiesCache.getInstance().getValue("mail", "mail.threadpool.maxqueue"));
         nbCoreThread = Integer.parseInt(FilesPropertiesCache.getInstance().getValue("mail", "mail.threadpool.nbcorethread"));
         nbMaxThread = Integer.parseInt(FilesPropertiesCache.getInstance().getValue("mail", "mail.threadpool.nbmaxthread"));
         keepAliveTime = Long.parseLong(FilesPropertiesCache.getInstance().getValue("mail", "mail.threadpool.keepalivetime"));
         waitShutdown = Integer.parseInt(FilesPropertiesCache.getInstance().getValue("mail", "mail.threadpool.waitshutdown"));
         debug = Boolean.getBoolean(FilesPropertiesCache.getInstance().getValue("mail", "mail.threadpool.debug"));
         if (keepAliveTime==0) keepAliveTime=Long.MAX_VALUE;
      } catch (Exception ex) {
         LogCommun.major("COMMUN","ThreadPoolMailSender","initThreadPool","Impossible de recuperer les parametres d'initialisation du pool de thread, utilisation de valeurs par defaut");
         maxQueue = 200;
         nbCoreThread = 2;
         nbMaxThread = 2;
         keepAliveTime = Long.MAX_VALUE;
         waitShutdown = 10;
         debug=false;
      }

      try {
         if (LogCommun.isTechniqueDebug()) LogCommun.debug("ThreadPoolMailSender","initThreadPool","fin init thread pool");
         taskQueue = new PriorityBlockingQueue();
         if (LogCommun.isTechniqueDebug()) LogCommun.debug("ThreadPoolMailSender","initThreadPool","init queue OK");
         executor = new PausableThreadPoolExecutor(nbCoreThread,nbMaxThread,keepAliveTime,TimeUnit.SECONDS,taskQueue,maxQueue,waitShutdown,debug);
         if (LogCommun.isTechniqueDebug()) LogCommun.debug("ThreadPoolMailSender","initThreadPool","int executor OK");
         // pour test, on block l'executor, on remplit juste la queue
         //executor.pause();
      } catch (Exception ex){
         LogCommun.major("COMMUN","ThreadPoolMailSender","initThreadPool","Impossible d'instancier le pool de thread ??? : "+ex.toString());
       }
   }

   /**
    * Force la r�instanciation de l'executor et de la queue
    */
   public static synchronized void forceReload() {
      synchronized (executor) { initThreadPool();}
   }

   /**
    * Appel la proc�dure statique de reload
    * si l'executor est stopp� ou null, on r�instancie
    */
   public void reload(){
      // si on est available on reload les propri�t�s avec syncreload,
      // sinon on a d�j� r�g�n�r� un nouveau pool donc pas besoin de syncreload
      if (runAvailabilityGuardian())
         syncReload();
   }

   /**
    * Reload les propri�t�s de l'executor sans r�instancier
    */
   public static synchronized void syncReload(){
        synchronized (executor) {
           // on se contente de recharger les propri�t�s accesibles par un setter.

           LogCommun.debug("ThreadPoolMailSender","initThreadPool","init thread pool");
           int maxQueue,nbCoreThread,nbMaxThread,waitShutdown;
           long keepAliveTime;

           try {
              FilesPropertiesCache.getInstance().reloadProperties("mail");
              maxQueue = Integer.parseInt(FilesPropertiesCache.getInstance().getValue("mail", "mail.threadpool.maxqueue"));
              nbCoreThread = Integer.parseInt(FilesPropertiesCache.getInstance().getValue("mail", "mail.threadpool.nbcorethread"));
              nbMaxThread = Integer.parseInt(FilesPropertiesCache.getInstance().getValue("mail", "mail.threadpool.nbmaxthread"));
              keepAliveTime = Long.parseLong(FilesPropertiesCache.getInstance().getValue("mail", "mail.threadpool.keepalivetime"));
              waitShutdown = Integer.parseInt(FilesPropertiesCache.getInstance().getValue("mail", "mail.threadpool.waitshutdown"));
              if (keepAliveTime==0) keepAliveTime=Long.MAX_VALUE;
           } catch (Exception ex) {
              LogCommun.major("COMMUN","ThreadPoolMailSender","initThreadPool","Impossible de recuperer les parametres d'initialisation du pool de thread, utilisation de valeurs par defaut");
              maxQueue = 200;
              nbCoreThread = 2;
              nbMaxThread = 2;
              keepAliveTime = Long.MAX_VALUE;
              waitShutdown = 10;
           }

           executor.setMaxCapacity(maxQueue);
           executor.setCorePoolSize(nbCoreThread);
           executor.setMaximumPoolSize(nbMaxThread);
           executor.setKeepAliveTime(keepAliveTime,TimeUnit.SECONDS);
           executor.setWaitShutdown(waitShutdown);

        }
    }

   /**
    * envoi d'un email au pool de thread
    * @param email : l'email � envoyer
    * @throws MailException
    */
   public void send(Email email) throws MailException{
      runAvailabilityGuardian();
      LogCommun.debug("ThreadPoolMailSender","initThreadPool","submit d'une nouvelle tache au pool de thread");
      try {
         MailSenderTask newTask = new MailSenderTask(email);

         // si l'executor est plein, prevoir d'attendre quelques instants ?? ou d'augmenter la limite "th�orique" ?
         if (executor.isFull()) {
            if (LogCommun.isTechniqueDebug()) LogCommun.debug("ThreadPoolMailSender","initThreadPool","Queue du pool de thread a atteint la capacite max");
            throw new RejectedExecutionException();
         }

         executor.execute(newTask);

         if (LogCommun.isTechniqueDebug()) LogCommun.debug("ThreadPoolMailSender","initThreadPool","Submit d'une nouvelle tache au pool de thread avec succes !");

      } catch (RejectedExecutionException ex){
         throw new MailException("Mail rejete, queue pleine !!!!!");
      }
   }

}
