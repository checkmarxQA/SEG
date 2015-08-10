package com.accor.asa.commun.user.metier.exception;

/**
 * Exception renvoy�e si l'utilisateur est inconnu du syst�me
 * @author	David Dreistadt
 */
@SuppressWarnings("serial")
public class UtilisateurInexistantException extends Exception {
/**
 * UtilisateurInexistantException constructor comment.
 * @param s java.lang.String
 */
public UtilisateurInexistantException(String s) {
	super(s);
}
}