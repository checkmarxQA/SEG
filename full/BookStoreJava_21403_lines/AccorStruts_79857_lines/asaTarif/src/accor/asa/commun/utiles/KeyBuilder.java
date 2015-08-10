package com.accor.asa.commun.utiles;

/**
 * Interface utilis�e par la m�thode Outils.getIndexedMap, 
 * permettant au d�veloppeur de sp�cifier quelle cl� utiliser pour indexer une liste 
 */
public interface KeyBuilder {
	/**
	 * Cree une cle d'index pour un element donn�.
	 * Attention, si la cl� est un objet m�tier, ne pas oublier de d�finir ses m�thodes equals() et hashCode()
	 */
	public Object getKey(Object element);
}
