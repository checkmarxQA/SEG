package com.accor.asa.commun.persistance;



/**
 * Cette classe est un descripteur de param�tres SQL.
 * Elle est utilis�e dans les DAO pour construire un tableau d'objets de type SQLParamDescriptor
 * qui est fourni � la classe qui execute la proc : SQLCallExecuter
 */
public class SQLParamDescriptor {

	private Object m_value; //valeur du param�tre (peut �tre null)
	private boolean m_isReturn; //indique si le param�tre est de type output (true) ou input(false)
	/**
     * @see java.sql.Types
	 */
    private int m_type;
    
    
    public SQLParamDescriptor(Object value, boolean isReturn) {
        this(value, isReturn, -1 );
        if (isReturn)
            throw new UnsupportedOperationException("Le type est obligatoire pour un param�tre output");
    }
    
    public SQLParamDescriptor(Object value) {
        this(value, false, -1 );
    }
    
    public SQLParamDescriptor(Object value, int type) {
        this(value, false, type );
    }
    
	public SQLParamDescriptor(Object value, boolean isReturn, int type) {
		m_value = value;
		m_isReturn = isReturn;
        m_type = type;
	}

    public boolean isReturn() {
        return m_isReturn;
    }

    public Object getValue() {
        return m_value;
    }

    /**
     * pour les param�tres de retour
     */
    public void setValue(Object object) {
        m_value = object;
    }
    
    public int getSqlType( ){
        return m_type;
    }
    
    public String toString()
    {
        String read = m_isReturn?"*":"-";
        return read + m_type + "-" + m_value;  
    }
}
