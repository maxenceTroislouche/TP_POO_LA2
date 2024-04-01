package Metier;

import jakarta.persistence.*;

@Entity
@Table(name = "TYPE_TIERS")
public class E_TypeTiers {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID_TYPE_TIERS")
    private long idTypeTiers;

    @Column(name = "LIB_TYPE_TIERS")
    private String libTypeTiers;

    public E_TypeTiers() {
    }

    public E_TypeTiers(long idTypeTiers, String libTypeTiers) {
        this.idTypeTiers = idTypeTiers;
        this.libTypeTiers = libTypeTiers;
    }

    public long getIdTypeTiers() {
        return idTypeTiers;
    }

    public void setIdTypeTiers(long idTypeTiers) {
        this.idTypeTiers = idTypeTiers;
    }

    public String getLibTypeTiers() {
        return libTypeTiers;
    }

    public void setLibTypeTiers(String libTypeTiers) {
        this.libTypeTiers = libTypeTiers;
    }

    @Override
    public String toString() {
        return "E_TypeTiers{" +
                "idTypeTiers=" + idTypeTiers +
                ", libTypeTiers='" + libTypeTiers + '\'' +
                '}';
    }
}
