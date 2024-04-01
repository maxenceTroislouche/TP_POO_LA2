package Metier;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "BIEN")
public class E_Bien {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID_BIEN")
    private long id;

    @Column(name = "LIB_BIEN")
    private String lib;

    @Column(name = "ADR_NO_VOIE")
    private String adrNoVoie;

    @Column(name = "NOM_VOIE")
    private String nomVoie;

    @Column(name = "CODE_POSTAL")
    private String codePostal;

    @Column(name = "COMMUNE")
    private String commune;

    @Column(name = "COMPLEMENT_ADRESSE")
    private String complementAdresse;

    @Column(name = "DATE_CREATION")
    private Date dateCreation;

    @Column(name = "DATE_DERNIERE_MAJ")
    private Date dateDerniereMaj;

    @Column(name = "SURFACE_HABITABLE")
    private Float surfaceHabitable;

    @Column(name = "NOMBRE_PIECES")
    private int nombrePieces;

    public E_Bien() {

    }

    @Override
    public String toString() {
        return "E_Bien{" +
                "id=" + id +
                ", lib='" + lib + '\'' +
                ", adrNoVoie='" + adrNoVoie + '\'' +
                ", nomVoie='" + nomVoie + '\'' +
                ", codePostal='" + codePostal + '\'' +
                ", commune='" + commune + '\'' +
                ", complementAdresse='" + complementAdresse + '\'' +
                ", dateCreation=" + dateCreation +
                ", dateDerniereMaj=" + dateDerniereMaj +
                ", surfaceHabitable=" + surfaceHabitable +
                ", nombrePieces=" + nombrePieces +
                '}';
    }
}
