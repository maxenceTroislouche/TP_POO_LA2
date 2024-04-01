package Metier;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "BAIL")
public class E_Bail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID_BAIL")
    private long id;

    @ManyToOne
    @JoinColumn(name = "ID_TIERS_AGENT")
    private E_Tiers agent;

    @Column(name = "DATE_EFFET_BAIL")
    private Date dateEffetBail;

    @Column(name = "DUREE_BAIL")
    private int dureeBail;

    @Column(name = "MOIS_RECONDUCTION_BAIL")
    private int moisReconductionBail;

    @Column(name = "DUREE_CONGE_DEPART")
    private int dureeCongeDepart;

    @Column(name = "LOYER_INITIAL")
    private float loyerInitial;

    @Column(name = "MONTANT_DERNIER_LOYER")
    private float montantDernierLoyer;

    @Column(name = "DATE_REVISION_ANNUELLE")
    private Date dateRevisionAnnuelle;

    @Column(name = "COMMENTAIRE_CALCUL")
    private String commentaireCalcul;

    @Column(name = "IRL_BASE")
    private String irlBase;

    @Column(name = "VALEUR_IRL_BASE")
    private float valeurIrlBase;

    @Column(name = "PROVISION_CHARGES")
    private float provisionCharges;

    @Column(name = "OBJET_CHARGES")
    private String objetCharges;

    @Column(name = "JOUR_ECHEANCE")
    private int jourEcheance;

    @Column(name = "MODE_REGLEMENT")
    private String modeReglement;

    @Column(name = "MONTANT_DEPOT_GARANTIE")
    private float montantDepotGarantie;

    @ManyToOne
    @JoinColumn(name = "ID_BIEN")
    private E_Bien bien;

    @Column(name = "DATE_RECEPTION_PREAVIS_FIN")
    private Date dateReceptionPreavisFin;

    @Column(name = "DATE_FIN_BAIL")
    private Date dateFinBail;

    @Column(name = "VALIDE")
    private int valide;

    @Column(name = "ETAT_BAIL")
    private String etatBail;

    @ManyToOne
    @JoinColumn(name = "ID_DESTINATION")
    private E_Destination destination;

    public E_Bail() {

    }

    @Override
    public String toString() {
        return "E_Bail{" +
                "id=" + id +
                ", agent=" + agent +
                ", dateEffetBail=" + dateEffetBail +
                ", dureeBail=" + dureeBail +
                ", moisReconductionBail=" + moisReconductionBail +
                ", dureeCongeDepart=" + dureeCongeDepart +
                ", loyerInitial=" + loyerInitial +
                ", montantDernierLoyer=" + montantDernierLoyer +
                ", dateRevisionAnnuelle=" + dateRevisionAnnuelle +
                ", commentaireCalcul='" + commentaireCalcul + '\'' +
                ", irlBase='" + irlBase + '\'' +
                ", valeurIrlBase=" + valeurIrlBase +
                ", provisionCharges=" + provisionCharges +
                ", objetCharges='" + objetCharges + '\'' +
                ", jourEcheance=" + jourEcheance +
                ", modeReglement='" + modeReglement + '\'' +
                ", montantDepotGarantie=" + montantDepotGarantie +
                ", bien=" + bien +
                ", dateReceptionPreavisFin=" + dateReceptionPreavisFin +
                ", dateFinBail=" + dateFinBail +
                ", valide=" + valide +
                ", etatBail='" + etatBail + '\'' +
                ", destination=" + destination +
                '}';
    }
}
