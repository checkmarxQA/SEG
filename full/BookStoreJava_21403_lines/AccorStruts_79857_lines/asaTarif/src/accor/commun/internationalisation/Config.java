package com.accor.commun.internationalisation;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

/**
 * Cache sur fichier de propri�t�s : config.properties
 */

public class Config {
    public static final String PROPERTY_FILE_NAME = "config.properties";
    public static final String SNMI = "SNMI";
    public static final String ECO  = "ECO";
    private static Properties config = new Properties();
    private static boolean isInitialized;
    private static String path;
    
    public static String getParametre(String nom) {
        if (!isInitialized)
            initialize();
        return config.getProperty(nom);
    }
    
    private static void initialize() {
        File f = null;
        try {
            f = new File(getFullPropertyFilename(PROPERTY_FILE_NAME));
            isInitialized = true;
	        config.load(new FileInputStream(f));
	    } catch (FileNotFoundException ex) {
	        System.err.println("Fichier <" + f.getAbsolutePath() + "> introuvable");
	    } catch (IOException ex) {
	        System.err.println("PROBLEME d'IO avec le fichier <" + f.getAbsolutePath() + ">");			
	    }
    }

    public static String getFullPropertyFilename(String filename)
    {
	// Par exemple filename = config.properties
	// La m�thode va retourner le chemin complet en ajoutant au filename
	//fournit en param�tre la valeur de la variable d'environnement accor_properties_path
	// pass�e en param�tre de l'ex�cution de la jvm
	// Si cette variable n'est pas trouv�e, on prend le r�pertoire courant.
	try 
	{
		path = System.getProperty("accor.accorhotels.propertyDir",".");
	}
	catch (SecurityException e)
	{
		System.out.println("Droits insuffisants pour la r�cup�ration de la variable d'environnement");
	}
	return path+File.separator+filename;

    }

}
