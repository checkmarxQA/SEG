/*
 * Created on 29 mars 04
 */
package com.accor.asa.commun.cache.metier;

import com.accor.asa.commun.process.IncoherenceException;

/**
 * Exception retourn� en cas de nullit� des donn�es de r�f�rence.
 */
@SuppressWarnings("serial")
public class DonneesReferencesNullException extends IncoherenceException {

    /**
     * @param message
     */
    public DonneesReferencesNullException(String message) {
        super(message);
    }

}
