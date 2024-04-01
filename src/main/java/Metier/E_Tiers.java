package Metier;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "TIERS")
public class E_Tiers {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID_TIERS")
    private long id;

    @Column(name = "NOM_TIERS")
    private String nom;

    @Column(name = "PRENOM_TIERS")
    private String prenom;

    @Column(name = "TEL_TIERS")
    private String tel;

    @Column(name = "MAIL_TIERS")
    private String mail;

    @JoinColumn(name = "TYPE_TIERS")
    @ManyToOne
    private E_TypeTiers typeTiers;

    @Column(name = "NAISSANCE_TIERS")
    private Date naissance;

    @Column(name = "ADRESSE_TIERS")
    private String adresse;

    @Column(name = "CP_TIERS")
    private String cp;

    @Column(name = "VILLE_TIERS")
    private String ville;

    @Column(name = "PIECE_IDENTITE_TIERS")
    private String pieceIdentite;

    @Column(name = "RIB_TIERS")
    private String rib;

    @Column(name = "NUMERO_SS_TIERS")
    private String numeroSS;

    public E_Tiers() {

    }

    @Override
    public String toString() {
        return "E_Tiers{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", tel='" + tel + '\'' +
                ", mail='" + mail + '\'' +
                ", typeTiers=" + typeTiers +
                ", naissance=" + naissance +
                ", adresse='" + adresse + '\'' +
                ", cp='" + cp + '\'' +
                ", ville='" + ville + '\'' +
                ", pieceIdentite='" + pieceIdentite + '\'' +
                ", rib='" + rib + '\'' +
                ", numeroSS='" + numeroSS + '\'' +
                '}';
    }
}
