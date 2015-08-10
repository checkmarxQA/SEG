package com.accor.asa.commun.log;

/**
 * acces direct aux m�thodes de log
 * � n'utiliser que dans Commun (d'o� le nom diff�rent des autres modules)
 */
public class LogCommun {
    private static final String MODULE = "Commun";

    /**
     * Tracer une erreur mineure (Erreur metier)
     */
    public static void minor(String codeUtilisateur, String objet, String methode, String message)  {
        LogHelper.minor(MODULE, codeUtilisateur, objet, methode, message);
    }

    /**
     * Tracer une erreur mineure (Erreur metier)
     */
    public static void minor(String codeUtilisateur, String objet, String methode, String message, Exception exception) {
        LogHelper.minor(MODULE, codeUtilisateur, objet, methode, message, exception);
    }

    /**
     * Tracer une erreur majeure (Erreur AccesDonnes)
     */
    public static void major(String codeUtilisateur, String objet, String methode, String message) {
        LogHelper.major(MODULE, codeUtilisateur, objet, methode, message);
    }

    /**
     * Tracer une erreur majeure (Erreur AccesDonnes)
     */
    public static void major(String codeUtilisateur, String objet, String methode, String message, Throwable exception) {
        LogHelper.major(MODULE, codeUtilisateur, objet, methode, message, exception);
    }

    /**
     * Tracer une erreur critique (Erreur Tronc Commun, BD)
     */
    public static void critical(String codeUtilisateur, String objet, String methode, String message)  {
        LogHelper.critical(MODULE, codeUtilisateur, objet, methode, message);
    }

    /**
     * Tracer une erreur critique (Erreur Tronc Commun, BD)
     */
    public static void critical(String codeUtilisateur, String objet, String methode, String message, Exception exception) {
        LogHelper.critical(MODULE, codeUtilisateur, objet, methode, message, exception);
    }

    /**
     * Tracer un service metier occasionnant une ecriture en base
     *
     * @param codeUtilisateur
     * @param labelObject Label de l'objet fournissant le service metier
     * @param service Service effectuant une ecriture en base
     */
    public static void traceFonctionnelle(
            String codeUtilisateur, String nomTable,
            String typeAction,String cle, String messageComplementaire) {
        LogHelper.traceFonctionnelle(MODULE, codeUtilisateur, nomTable, typeAction, cle, messageComplementaire);
    }

    /**
     * Tracer un service metier occasionnant un ecriture en base
     *
     * @param codeUtilisateur
     * @param labelObject Label de l'objet fournissant le service metier
     * @param service Service effectuant une ecriture en base
     */
    public static void traceFonctionnelle(
        String codeUtilisateur, String nomTable,
        String typeAction, String cle) {
        LogHelper.traceFonctionnelle(MODULE, codeUtilisateur, nomTable, typeAction, cle);
    }

    /**
     * Affichage de debugging
     */
    public static void debug(String objet, String methode, String message) {
        LogHelper.debug(MODULE, objet, methode, message);
    }

    /**
     * Affichage de warning
     */
    public static void warn(String codeUtilisateur,String objet, String methode, String message) {
        LogHelper.warn(MODULE, codeUtilisateur, objet, methode, message);
    }

    /**
     * Affichage d'information
     */
    public static void info(String codeUtilisateur, String objet, String methode, String message) {
        LogHelper.info(MODULE, codeUtilisateur, objet, methode, message);
    }



   /**
     * Tracer un service metier occasionnant un ecriture en base
     *
     * @param codeUtilisateur
     * @param labelObject Label de l'objet fournissant le service metier
     * @param service Service effectuant une ecriture en base
     */
    public static void traceOptim(String labelObjet, String service, String params) {
        LogHelper.traceOptim(labelObjet, service, params);
    }

    /**
     * Tracer un appel TC
     *
     * @param url
     * @param labelObject Label de l'objet fournissant le service metier
     * @param service Service effectuant une ecriture en base
     */
    public static void traceTC( String codeUtilisateur, String url ) {
        LogHelper.traceTC(MODULE, codeUtilisateur, url);
    }

    /**
     * Tracer un appel passant par le pool QBE
     *
     * @param codeUtilisateur :  Login de l'utilisateur effectuant l'appel
     * @param query : requete dynamique ou appel d'une procedure stockee via le pool QBE
     * @param nbRows : nb enregistrements retourner par l appel
     */
    public static void traceQBE( String codeUtilisateur, String query, int nbRows ) {
        LogHelper.traceQBE(MODULE, codeUtilisateur, query, nbRows);
    }
    
    /**
     * Tracer un appel de droit d'habilitations
     * @param message : liste s�par�e par des "|" des param�tres
     */
    public static void traceHabilitations( String message ) {
        LogHelper.traceHabilitations(message);
    }
    
    public static boolean isTechniqueDebug() {
        return LogHelper.isTechniqueDebug;       
    }

    public static boolean isFonctionelleDebug() {
        return LogHelper.isFonctionelleDebug;       
    }

    public static boolean isTransfertDebug() {
        return LogHelper.isTransfertDebug;       
    }

    public static boolean isHabilitationsDebug() {
        return LogHelper.isHabilitationsDebug;       
    }

    public static boolean isTCDebug() {
        return LogHelper.isTCDebug;       
    }

    public static boolean isQBEDebug() {
        return LogHelper.isQBEDebug;       
    }

    public static boolean isOptimDebug() {
        return LogHelper.isOptimDebug;       
    }
}