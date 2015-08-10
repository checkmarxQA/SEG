package com.accor.asa.commun.utiles;

/**
 * Classe d'aide pour l'affichage dans les JSP
 * - coupure des string trop longue
 */
public class HtmlFormatHelper {

    private int largeurMaxCaractere;
    private static HtmlFormatHelper instance;
    private static final String PROPRIETE_LARGEUR = "html.format.coupure.defaut";

    private HtmlFormatHelper() {
        try {
            String s = FilesPropertiesCache.getInstance().getValue(Proprietes.PROPERTIES_FILE_NAME,PROPRIETE_LARGEUR, "10");
            largeurMaxCaractere = Integer.parseInt(s);
        }
        catch (Exception e) {
            largeurMaxCaractere = 10;
        }
    }

    public static HtmlFormatHelper getInstance() {
        if (instance == null)
            instance = new HtmlFormatHelper();

        return instance;
    }

    /**
     * decoupage d'une ligne en inserant des blancs cach�s
     * qui permet le copier coller tout en permettant 
     * un affichage correct dans un tableau HTML
     * <BR> Attention : le d�coupage se fait sur une estimation approximative
     * de la largeur des caract�res
     * @param largeurPixel : largeur max en pixel
     * @param ligne : string d'entr�e
     */
    public String decouperLigne(String ligne, int largeurPixel) {

        int whiteCounter = 0;
        String result = "";

        if (ligne != null) {
            int longueurLigne = ligne.length();
            for (int i = 0; i < longueurLigne; i++) {

                if (ligne.substring(i, i + 1).equals(" ")) {
                    whiteCounter = 0;
                }
                else {
                    whiteCounter += 1;
                }
                result += ligne.substring(i, i + 1);

                if (whiteCounter == largeurPixel) {
                    whiteCounter = 0;
                    result += "<WBR>";
                }
            }
        }

        return result;
    }
    /**
     * decoupage d'une ligne en inserant des blancs cach�s tous les 10 caract�res
     * qui permet le copier coller tout en permettant 
     * un affichage correct dans un tableau HTML
     * <BR> Attention : le d�coupage se fait sur une estimation approximative
     * de la largeur des caract�res
     * @param ligne : string d'entr�e
     */
    public String decouperLigne(String ligne) {

        String result = "";
        decouperLigne(ligne, largeurMaxCaractere);

        /*		int longueurLigne = ligne.length();
        		int whiteCounter = 0;
        		
        			
        		for ( int i=0; i < longueurLigne ;i++ ){
        			
        			if (ligne.substring(i,i+1).equals(" ")){
        				whiteCounter=0;
        			}
        			else {
        				whiteCounter += 1;
        			}
        			result.concat(ligne.substring(i,i+1));
        			
        			if (whiteCounter == largeurMaxCaractere){
        				whiteCounter = 0;
        				result.concat("<WBR>");
        			}	
        		}*/
        return result;
    }

    /**
     * coupe les chiffres apr�s la virgule (ou le point)
     * n'ajoute pas de z�ros ni de virgule pour compl�ter
     */
    public String formatNumber( String number, int nbMaxDigits ) {
        String sFormated = number;
        if ( number != null ) {
            try {
                int length = number.length();
                int nSep = number.lastIndexOf(',');
                if ( nSep < 0 )
                    nSep = number.lastIndexOf('.');
                if ( nSep >= 0 ) {
                    int cut = nSep + nbMaxDigits + 1;
                    if ( cut > length )
                        cut = length;
                    sFormated = number.substring(0,cut);
                }
            }
            catch (Exception e) {
            }
        }
        return sFormated;
    }

    /**
     * Fonction permet de compl�ter ce nombre par la gauche avec un nombre pr�cis de z�ros
     * Nombre de z�ros compl�mentaires=nbreChiffres-value.long
     * @param value
     * @param nbreChiffres
     * @return
     */
    public String getNumberCompleterParDesZeros(int value, int nbreChiffres){
        String retour = "";
        try {
            retour = String.valueOf(value);
            int dif = nbreChiffres-retour.length();
            if (dif > 0)
                for (int i=0; i < dif; i++)
                    retour = new StringBuffer("0").append(retour).toString();
        } catch (Exception ex) {

        }
        return retour;
    }
}