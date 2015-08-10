package com.accor.asa.commun.services.mail;

/**
 * MailSender est utilis� pour d�finr qu'un object peu envoyer un email.<br>
 * Pour propser d'autre methodes d'envoi, il est BEAUCOUP plus interessant d'etendre MailSenderProxy.
 * @see MailSenderProxy
 * @author <a href="mailto:LEHYARIC_Gildas@accor-hotels.com">gle</a>
 * @version $Id: MailSender.java,v 1.4 2006/02/08 19:39:12 dgo Exp $
 */

public interface MailSender {

    /**
     * Envoie l'email <code>email</code>
     * @param email email � envoyer
     * @throws MailException
     */
    void send(Email email) throws MailException;

    public void reload() throws Exception;
    // ne pas rajouter de m�thode d'envoi ici, mais plutot dans MailSenderProxy

}