package com.accor.asa.commun.habilitation.metier;

/**
 * Classe repr�sentant une erreur fonctionnelle d'habilitation (action interdite)
 * @author	Jerome Pietri
 */
@SuppressWarnings("serial")
public class HabilitationException extends Exception {
/**
 * HabilitationException constructor comment.
 * @param s java.lang.String
 */
public HabilitationException(String s) {
	super(s);
}
}