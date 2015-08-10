package com.accor.asa.commun.persistance;

import java.sql.ResultSet;
import java.sql.SQLException;

import com.accor.asa.commun.TechnicalException;

/**
 * Interface � impl�menter pour specifier comment un r�sultSet doit �tre interpret�
 * (une impl�mentation de SQLResultSetReader correspond a un select particulier et est d�pendant des colonnes retourn�es)
 */
public interface SQLResultSetReader 
{
    /**
     * Cr�e un objet m�tier repr�sentant une ligne du r�sultset.
     * Typiquement :
     * 
     * MaClasseMetier instance = new MaClasseMetier();
     * instance.setAttribut1(rs.getString("ATTRIBUT1");
     * ...
     * return instance;
     * 
     * 
     * ATTENTION : N'utiliser que des m�thodes getXXX() dans l'impl�mentation de cette m�thode 
     */
    public Object instanciateFromLine(ResultSet rs) throws TechnicalException, SQLException; 
}
