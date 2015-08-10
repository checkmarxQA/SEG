package com.accor.asa.commun.services.mail;

/**
 * Interface de la classe devant etre utilis�e pour valider une adresse email.
 * <p>
 *     le nom de l'implementation doit etre renseign�e dnas le fichier de mail.properties:
 * <pre>
 *     mail.emailvalidator = com.accor.asa.commun.services.mail.RegExpEmailAddressValidator
 * </pre>
 *
 * l'impl�mentation doit avoir un constructeur public sans argument.
 *
 * </p>
 * @author <a href="mailto:LEHYARIC_Gildas@accor-hotels.com">lehyaric</a>
 * @version $Id: EmailAddressValidator.java,v 1.3 2005/06/08 12:00:08 gle Exp $
 */
public interface EmailAddressValidator {

    /**
     * Valide le fait que la chaine <code>email</code> reprsente une adresse email ou non.
     * @param email l'adresse a tester
     * @return true si l'adresse est valide, false sinon
     */
    boolean validate(String email);

}
