package Metier;

import jakarta.persistence.*;

@Entity
@Table(name = "DESTINATION")
public class E_Destination {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID_DESTINATION")
    private long id;

    @Column(name = "LIB_DESTINATION")
    private String lib;

    public E_Destination() {

    }

    @Override
    public String toString() {
        return "E_Destination{" +
                "id=" + id +
                ", lib='" + lib + '\'' +
                '}';
    }
}
