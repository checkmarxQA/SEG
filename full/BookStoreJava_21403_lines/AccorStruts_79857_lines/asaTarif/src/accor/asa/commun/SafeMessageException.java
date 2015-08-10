package com.accor.asa.commun;

/**
 * classe g�n�rique d'exception avec message sp�cifique
 * <br>
 * Cr�e afin d'�viter d'�te "pollu�" par Weblogic 6 qui modifie de fa�on 
 * intempestive le message (en faisant un setMessage()), notamment en lui
 * collant la stack au derri�re.
 */
@SuppressWarnings("serial")
public class SafeMessageException extends Exception {

    /**
     * message propri�taire de l'erreur, garanti non modifi� depuis sa cr�ation
     */
    private String m_messageOrigine = null;
    
    public SafeMessageException( ) {
        super();
    }
    
    public SafeMessageException( String message ) {
        super(message);
        m_messageOrigine = message;
    }
    
    /**
     * @param orgMessage si vrai, on retourne le message tel que fourni � sa cr�ation
     */
    public String getMessage(boolean orgMessage) {
        if (orgMessage) 
            return m_messageOrigine;
        else
            return super.getMessage();
    }

}
