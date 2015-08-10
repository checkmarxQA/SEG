package com.accor.asa.commun.donneesdereference.persistance;

import java.util.List;
import java.util.Map;

import com.accor.asa.commun.TechnicalException;
import com.accor.asa.commun.donneesdereference.metier.DonneeReference;
import com.accor.asa.commun.persistance.ContexteAppelDAO;
import com.accor.asa.commun.process.IncoherenceException;

/*
 * interface impl�ment�e par tous les DAOs sp�cifiques � chaque classe de donnee de reference.
 * Chaque sous classe est charg�e par l'EJB DonneeRefGeneriqueBean de facon dynamique.
 * cet EJB utilise le polymorphisme pour appeler les DAO de chaque type. 
 */
public interface DonneeRefDAO {
    public List getDonneesRef(String codeLangue, ContexteAppelDAO context) throws TechnicalException;

    public Map getDonneesRefIntoMap(String codeLangue, ContexteAppelDAO context) throws TechnicalException;
    /*
     * @throws IncoherenceException si le type du param�tre ne correspond pas au type attendu.
     * (chaque impl�mentation de DonneeRefDAO est sp�cifique pour un type de donnee de reference)
     */
    public void insertDonneeRef(DonneeReference donnee, ContexteAppelDAO contexte) throws TechnicalException, IncoherenceException;

    /*
     * @throws IncoherenceException si le type du param�tre ne correspond pas au type attendu.
     * (chaque impl�mentation de DonneeRefDAO est sp�cifique pour un type de donnee de reference)
     */
    public void updateDonneeRef(DonneeReference donnee, ContexteAppelDAO context) throws TechnicalException, IncoherenceException;

    public void deleteDonneeRef(String codeDonneeRef, ContexteAppelDAO context) throws TechnicalException;

    public List getDonneesRefAdmin(ContexteAppelDAO context) throws TechnicalException;
}