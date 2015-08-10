package com.accor.asa.commun.persistance;


/**
 * jeu de param�tres pour un appel de proc�dure
 */
public class SQLParamDescriptorSet {
    /**
     * liste de param�tres vide
     */
    public SQLParamDescriptorSet() {
    }

    private SQLParamDescriptor[] jeuDeParametresSQL;
   
    public SQLParamDescriptorSet(SQLParamDescriptor sqlParamDesc) {
        this (new SQLParamDescriptor[]{ sqlParamDesc });
    }

    public SQLParamDescriptorSet(SQLParamDescriptor[] sqlParamDescTable) {
        this.jeuDeParametresSQL = sqlParamDescTable;
    }
    
    public int size() {
        if ( jeuDeParametresSQL != null )
            return jeuDeParametresSQL.length;
        else
            return 0;
    }
    
    public SQLParamDescriptor getParameter(int index)
    {
        return jeuDeParametresSQL[index];
    }
    
    public String toString()
    {
        if (jeuDeParametresSQL == null) return "[]";
        String result = "[";
        for (int i=0 ; i<jeuDeParametresSQL.length ; i++)
        {
        	if (jeuDeParametresSQL[i] == null) throw new RuntimeException("Le param�tre � l'index " + i + " n'a pas �t� initialis� dans le SQLParamDescriptor");
            result += jeuDeParametresSQL[i].toString();
            if (i<jeuDeParametresSQL.length-1) result += ", ";
        }
        result += "]";
        return result;
    }
}
