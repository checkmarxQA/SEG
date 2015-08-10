package com.accor.commun.internationalisation;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Vector;

import com.accor.asa.commun.cache.metier.CacheManager;
import com.accor.asa.commun.log.LogCommun;
import com.accor.asa.commun.metier.MapTranslateKey;
import com.accor.asa.commun.persistance.AsaJDBCConfig;

/**
 * Cette classe impl�mente le mod�le de ResourceBundle n�cessaire au chargement de toutes les langues de l'application.
 * L'acc�s aux donn�es du Bundle se fait depuis une base de donn�es.
 * La connection � la base de donn�e se fait au travers d'une propri�t� d�finie dans le fichier properties de Weblogic ("ConnectionPool").
 * Cette classe sera �tendue par n sous-classes (suffix�es par la langue correspondante) dans lesquels les ressources de la langue associ�e seront acc�d�es.
 * @author Vincent Miramond Valtech
 */

public class DBResourceBundle extends ResourceBundle
{

	/**
	 * Constante permettant de r�cup�rer la valeur de la colonne servant de cl� primaire dans le SGBDR.
	 */
	private static final String KEYS = "cle";
	/**
	 * Constante permettant de r�cup�rer le code langue dans le SGBDR.
	 */

	protected static final String CODELANGUE = "codeLangue";

	/**
	 * Constante permettant de r�cup�rer la valeur de la colonne servant � stocker le libelle dans le SGBDR.
	 */
	protected static final String LIBELLE = "libelle";

	/**
	 * Constante permettant d'identifier la langue.
	 */
	protected static final String FR = "fr";
	protected static final String DE = "de";
	protected static final String ES = "es";
	protected static final String EN = "eng";
	protected static final String IT = "it";
	protected static final String PT = "pt";
	protected static final String NL = "nl";
	protected static final String HU = "hu";

	/**
	 * Permet de stocker toutes les cl�s � traduire, et d'y acc�der facilement sous la forme d'une Enumeration (jdk1.0 et 1.1).
	 */
	private static Vector<String> keys = null;

	private static int SYBASE_DEADLOCK_ERROR_CODE = 1205;

	public DBResourceBundle() {
		super();
	}

	/**
	 * Acc�sseur pour la Map stockant les couples cl�/valeur fran�ais.
	 * @return la Map stockant les traductions fran�aises.
	 */
	protected Map<String, String> getHashFR()
	{
		MapTranslateKey map = (MapTranslateKey)
			CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, FR );

		if( map == null ) {
			loadResourceBundle();
			map = (MapTranslateKey)
					CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, FR );
		}

		return map.getTranslateKey();
	}

	/**
	 * Acc�sseur pour la Map stockant les couples cl�/valeur anglais.
	 * @return la Map stockant les traductions anglaises.
	 */
	protected Map<String, String> getHashENG()
	{
		MapTranslateKey map = (MapTranslateKey)
				CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, EN );

		if( map == null ) {
			loadResourceBundle();
			map = (MapTranslateKey)
					CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, EN );
		}

		return map.getTranslateKey();
	}

	/**
	 * Acc�sseur pour la Map stockant les couples cl�/valeur allemands.
	 * @return la Map stockant les traductions allemandes.
	 */
	protected Map<String, String> getHashDE()
	{
		MapTranslateKey map = (MapTranslateKey)
				CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, DE );

		if( map == null ) {
			loadResourceBundle();
			map = (MapTranslateKey)
					CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, DE );
		}

		return map.getTranslateKey();
	}

	/**
	 * Acc�sseur pour la Map stockant les couples cl�/valeur espagnols.
	 * @return la Map stockant les traductions espagnoles.
	 */
	protected Map<String, String> getHashES()
	{
		MapTranslateKey map = (MapTranslateKey)
			CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, ES );

		if( map == null ) {
			loadResourceBundle();
			map = (MapTranslateKey)
					CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, ES );
		}

		return map.getTranslateKey();
	}

	/**
	 * Acc�sseur pour la Map stockant les couples cl�/valeur italiens.
	 * @return la Map stockant les traductions italiennes.
	 */
	protected Map<String, String> getHashIT()
	{
		MapTranslateKey map = (MapTranslateKey)
			CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, IT );

		if( map == null ) {
			loadResourceBundle();
			map = (MapTranslateKey)
					CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, IT );
		}

		return map.getTranslateKey();
	}

	/**
	 * Acc�sseur pour la Map stockant les couples cl�/valeur n�erlandais.
	 * @return la Map stockant les traductions n�erlandaises.
	 */
	protected Map<String, String> getHashNL()
	{
		MapTranslateKey map = (MapTranslateKey)
			CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, NL );

		if( map == null ) {
			loadResourceBundle();
			map = (MapTranslateKey)
					CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, NL );
		}

		return map.getTranslateKey();
	}

	/**
	 * Acc�sseur pour la Map stockant les couples cl�/valeur portugais.
	 *@return la Map stockant les traductions portugaises.
	 */
	protected Map<String, String> getHashPT()
	{
		MapTranslateKey map = (MapTranslateKey)
			CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, PT );

		if( map == null ) {
			loadResourceBundle();
			map = (MapTranslateKey)
					CacheManager.getInstance().getObjectInCache( MapTranslateKey.class, PT );
		}

		return map.getTranslateKey();
	}

	/**
	 * Acc�sseur pour la Map stockant les couples cl�/valeur hongrois.
	 * @return la Map stockant les traductions hongroises.
	 */
	protected Map<String, String> getHashHU () {
		MapTranslateKey map = (MapTranslateKey) CacheManager.getInstance().getObjectInCache(MapTranslateKey.class, HU);

		if (map == null) {
			loadResourceBundle();
			map = (MapTranslateKey) CacheManager.getInstance().getObjectInCache(MapTranslateKey.class, HU);
		}

		return map.getTranslateKey();
	}

	/**
	 * M�thode permettant d'acc�der � une traduction � partir d'une cl�.
	 * @param       key                 la cl� pour laquelle on d�sire acc�der � une traduction.
	 * @return      la traduction correspondant � la cl� pass�e en param�tre.
	 */
	public Object handleGetObject(String key) {
		Object returnValue = getHashENG().get(key);
		if (returnValue == null)
			returnValue = TranslatorFactory.LIBELLE_NON_PRESENT + key;
		return returnValue;
	}


	/**
	 * M�thode permettant d'acc�der � un it�rateur permettant de parcourir la liste des cl�s disponibles pour cette ressource.
	 * @return      la liste des cl�s disponibles, sous la forme d'un it�rateur.
	 */
	public Enumeration<String> getKeys()
	{
		getHashENG();
		return keys.elements();
	}

	public static void clearBundles() {
		CacheManager.getInstance().cleanCache( MapTranslateKey.class );
	}

	public static void clearABundles(String langue) {
		MapTranslateKey map = new MapTranslateKey( null, langue );
		CacheManager.getInstance().setObjectInCache( map );
	}

	/**
	 * Charge les differents ResourceBundle de l'application.
	 * Cette m�thode est appel�e depuis les sous-classes de la classe courante correspondant aux diff�rentes langues de l'application.
	 * L'ajout de nouvelles langues pour l'application n�cessite d'ajouter le code sp�cifique � toutes les langues � g�rer dans cette m�thode.
	 * @version 1.1 : la connection � la base se fait maintenant au travers du pool de connexion.
	 */
	synchronized protected void loadResourceBundle() {
		HashMap<String, String> tmpENG = new HashMap<String, String>();
		HashMap<String, String> tmpFR = new HashMap<String, String>();
		HashMap<String, String> tmpDE = new HashMap<String, String>();
		HashMap<String, String> tmpES = new HashMap<String, String>();
		HashMap<String, String> tmpIT = new HashMap<String, String>();
		HashMap<String, String> tmpPT = new HashMap<String, String>();
		HashMap<String, String> tmpNL = new HashMap<String, String>();
		HashMap<String, String> tmpHU = new HashMap<String, String>();

		keys = new Vector<String>();

		Connection cnt = null;
		Statement st = null;
		try {
			cnt = AsaJDBCConfig.getInstance().getConnectionPool().getConnection(AsaJDBCConfig.ASA_POOL);
			st = cnt.createStatement();
			CallableStatement proc = cnt.prepareCall("{call proc_sel_ResourceBundle (?)}");
			proc.setString(1,"");
			ResultSet rs = null;
			int nbEssais = 0;
			boolean saveOk = false;
			while ((nbEssais < 4) && (!saveOk)) {
				try {
					rs = proc.executeQuery();
						saveOk=true;
				} catch (SQLException e) {
					if (e.getErrorCode() == SYBASE_DEADLOCK_ERROR_CODE)
						nbEssais++;
				}
			}
			String key, codeLangue, libelle;
			while(rs.next()) {
				key         = rs.getString(KEYS);
				libelle     = rs.getString(LIBELLE);
				codeLangue  = rs.getString(CODELANGUE);
				keys.addElement(key);
				if (codeLangue.equalsIgnoreCase(FR))
					tmpFR.put(key,  libelle);
				else if (codeLangue.equalsIgnoreCase(DE))
					tmpDE.put(key,  libelle);
				else if (codeLangue.equalsIgnoreCase(ES))
					tmpES.put(key,  libelle);
				else if (codeLangue.equalsIgnoreCase(IT))
					tmpIT.put(key,  libelle);
				else if (codeLangue.equalsIgnoreCase(NL))
					tmpNL.put(key,  libelle);
				else if (codeLangue.equalsIgnoreCase(PT))
					tmpPT.put(key,  libelle);
				else if (codeLangue.equalsIgnoreCase(HU))
					tmpHU.put(key,  libelle);
				else
					tmpENG.put(key, libelle);
			}

			CacheManager c = CacheManager.getInstance();
			c.setObjectInCache( new MapTranslateKey( tmpFR,FR ) );
			c.setObjectInCache( new MapTranslateKey( tmpDE,DE ) );
			c.setObjectInCache( new MapTranslateKey( tmpES,ES ) );
			c.setObjectInCache( new MapTranslateKey( tmpIT,IT ) );
			c.setObjectInCache( new MapTranslateKey( tmpPT,PT ) );
			c.setObjectInCache( new MapTranslateKey( tmpNL,NL ) );
			c.setObjectInCache( new MapTranslateKey( tmpENG,EN ) );
			c.setObjectInCache(new MapTranslateKey(tmpHU, HU));
		}
		catch(Exception exc) {
			LogCommun.major("Weblogic","DBResourceBundle","loadResourceBundle",exc.getMessage());
		}
		finally {
			try {
				if (st != null) {
					st.close();
					st=null;
				}
			} catch (SQLException e) {
				LogCommun.major("Weblogic", "DBResourceBundle", "loadResourceBundle", e.getMessage());
			} finally {
				try {
					if (cnt != null && !cnt.isClosed()) {
						cnt.close();
					}
					cnt = null;
				} catch (SQLException e) {
					LogCommun.major("Weblogic", "DBResourceBundle", "loadResourceBundle", e.getMessage());
				}
			}
		}
	}

	/**
	 * Charge les differents ResourceBundle de l'application.
	 * Cette m�thode est appel�e depuis les sous-classes de la classe courante correspondant aux diff�rentes langues de l'application.
	 * L'ajout de nouvelles langues pour l'application n�cessite d'ajouter le code sp�cifique � toutes les langues � g�rer dans cette m�thode.
	 * @version 1.1 : la connection � la base se fait maintenant au travers du pool de connexion.
	 */
	synchronized protected void loadResourceBundle(String langue) {

		HashMap<String, String> tmpHsh = new HashMap<String, String>();
		keys = new Vector<String>();

		Connection cnt = null;
		Statement st = null;

		try {
			cnt = AsaJDBCConfig.getInstance().getConnectionPool().getConnection(AsaJDBCConfig.ASA_POOL);
			st = cnt.createStatement();
			CallableStatement proc = cnt.prepareCall("{call proc_sel_ResourceBundle (?)}");
			proc.setString(1,langue.substring(0,2));
			ResultSet rs;
			rs = proc.executeQuery();
			String key, libelle;
			while (rs.next()) {
				key         = rs.getString(KEYS);
				libelle     = rs.getString(LIBELLE);
				keys.addElement(key);
				tmpHsh.put(key, libelle);
			}

			CacheManager.getInstance().setObjectInCache( new MapTranslateKey( tmpHsh, langue ) );
		}
		catch (Exception exc) {
			LogCommun.major("Weblogic", "DBResourceBundle", "loadResourceBundle", exc.getMessage());
		} finally {
			try {
				if ( st != null ) {
					st.close();
					st=null;
				}
			} catch ( SQLException e ) {
				LogCommun.major("Weblogic", "DBResourceBundle", "loadResourceBundle", e.getMessage());
			} finally {
				try {
					if ( cnt != null && !cnt.isClosed()) {
						cnt.close();
					}
					cnt = null;
				} catch ( SQLException e ) {
					LogCommun.major("Weblogic", "DBResourceBundle", "loadResourceBundle", e.getMessage());
				}
			}
		}
	}

	public String getClassName() {
		return getClass().getName();
	}

	public void refresh(String option) {
		clearABundles(option);
	}

}