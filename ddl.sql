create table if not exists BIEN
(
    ID_BIEN            int auto_increment comment 'Identifiant du bien'
        primary key,
    LIB_BIEN           varchar(50)   not null comment 'description du bien',
    ADR_NO_VOIE        varchar(7)    null comment 'Numéro dans la voie',
    NOM_VOIE           varchar(100)  null comment 'Nom de la voie',
    CODE_POSTAL        varchar(5)    null comment 'Code postal de la commune',
    COMMUNE            varchar(100)  null comment 'Nom de la commune',
    COMPLEMENT_ADRESSE varchar(5)    null comment 'Exemple : N° appartement, étage ...',
    DATE_CREATION      datetime      not null,
    DATE_DERNIERE_MAJ  datetime      not null,
    SURFACE_HABITABLE  decimal(5, 2) not null,
    NOMBRE_PIECES      int default 1 not null
)
    engine = InnoDB;

create table if not exists DESTINATION
(
    ID_DESTINATION  int auto_increment
        primary key,
    LIB_DESTINATION varchar(100) not null
)
    engine = InnoDB;

create table if not exists BAIL
(
    ID_BAIL                    int auto_increment
        primary key,
    ID_TIERS_AGENT             int                              not null,
    DATE_EFFET_BAIL            date                             not null,
    DUREE_BAIL                 int           default 3          not null comment 'Durée du bail en années',
    MOIS_RECONDUCTION_BAIL     int                              not null comment 'Numéro du mois de reconduction du bail',
    DUREE_CONGE_DEPART         int           default 3          not null comment 'Durée du congé de départ en nombre de mois',
    LOYER_INITIAL              decimal(8, 2)                    not null,
    MONTANT_DERNIER_LOYER      decimal(8, 2) default 0.00       null,
    DATE_REVISION_ANNUELLE     date                             null,
    COMMENTAIRE_CALCUL         varchar(100)                     null,
    IRL_BASE                   varchar(20)                      null,
    VALEUR_IRL_BASE            decimal(5, 2)                    null,
    PROVISION_CHARGES          decimal(5, 2) default 0.00       not null,
    OBJET_CHARGES              varchar(100)                     null,
    JOUR_ECHEANCE              int           default 5          not null comment 'No du jour d''échéance, compris entre 1 et 10',
    MODE_REGLEMENT             varchar(5)                       null,
    MONTANT_DEPOT_GARANTIE     decimal(7, 2) default 0.00       not null,
    ID_BIEN                    int                              not null comment 'Identifiant du bien concerné',
    DATE_RECEPTION_PREAVIS_FIN date                             null,
    DATE_FIN_BAIL              date                             null,
    VALIDE                     int           default 0          not null,
    ETAT_BAIL                  varchar(10)   default 'EN COURS' null,
    ID_DESTINATION             int           default 1          not null invisible,
    constraint BAIL_DESTINATION_ID_DESTINATION_fk
        foreign key (ID_DESTINATION) references DESTINATION (ID_DESTINATION),
    constraint BAIL___fk_BIEN
        foreign key (ID_BIEN) references BIEN (ID_BIEN)
            on delete cascade
)
    engine = InnoDB;

create definer = ilg@localhost trigger BAIL_AFTER_INSERT
    after insert
    on BAIL
    for each row
BEGIN
    /* Recherche de tous les propriétaires du bien */
    DECLARE v_fin BOOLEAN DEFAULT FALSE;
    DECLARE v_id_tiers INT DEFAULT 0;
    DECLARE v_part_tiers INT DEFAULT 0;
    DECLARE v_curseur CURSOR FOR SELECT ID_TIERS,PART FROM PROPRIETE WHERE ID_BIEN = NEW.ID_BIEN;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin = TRUE;

    OPEN v_curseur;
    labelcurseur : LOOP
    FETCH v_curseur INTO v_id_tiers,v_part_tiers;
    IF v_fin THEN
     LEAVE labelcurseur;
    END IF;
    CALL CreationHonorairesProprietaire(NEW.ID_BAIL,v_id_tiers,v_part_tiers);
 END LOOP labelcurseur;
CLOSE v_curseur;
END;

create table if not exists TYPE_HONORAIRE
(
    ID_TYPE_HONORAIRE int auto_increment
        primary key,
    TYPE_HONORAIRE    varchar(100)                        not null,
    PAYE_PAR          char          default 'P'           not null,
    VALEUR_TARIF      decimal(5, 2) default 0.00          not null,
    TYPE_TARIF        varchar(100)  default 'POURCENTAGE' not null
)
    engine = InnoDB;

create table if not exists TYPE_TIERS
(
    ID_TYPE_TIERS  int auto_increment
        primary key,
    LIB_TYPE_TIERS varchar(100) null
)
    engine = InnoDB;

create table if not exists TIERS
(
    ID_TIERS             int auto_increment
        primary key,
    NOM_TIERS            varchar(100)                   not null comment 'Nom du tiers ou raison sociale',
    PRENOM_TIERS         varchar(100)                   null comment 'Prénom du tiers si personne physique',
    TEL_TIERS            varchar(10) default '00000000' not null comment 'No de téléphone du tiers',
    MAIL_TIERS           varchar(100)                   null comment 'Adresse mail du tiers',
    TYPE_TIERS           int         default 1          not null comment 'Type de tiers',
    NAISSANCE_TIERS      date                           null,
    ADRESSE_TIERS        varchar(100)                   null comment 'Adresse du tiers',
    CP_TIERS             char(5)                        null,
    VILLE_TIERS          varchar(100)                   null,
    PIECE_IDENTITE_TIERS varchar(1000)                  null comment 'Pièce identitié du tiers, chemin d accès au fichier',
    RIB_TIERS            varchar(1000)                  null comment 'RIB TIERS , chemin d accès au fichier',
    NUMERO_SS_TIERS      char(15)                       null,
    constraint TIERS_TYPE_TIERS_ID_TYPE_TIERS_fk
        foreign key (TYPE_TIERS) references TYPE_TIERS (ID_TYPE_TIERS)
)
    engine = InnoDB;

create table if not exists HONORAIRE
(
    ID_HONORAIRE      int auto_increment
        primary key,
    ID_TIERS          int           not null,
    ID_TYPE_HONORAIRE int           not null,
    ID_BAIL           int           not null,
    MONTANT_HONORAIRE decimal(7, 2) null,
    DATE_REGLEMENT    date          null,
    constraint HONORAIRE_TIERS_ID_TIERS_fk
        foreign key (ID_TIERS) references TIERS (ID_TIERS),
    constraint HONORAIRE_TYPE_HONORAIRE_ID_TYPE_HONORAIRE_fk
        foreign key (ID_TYPE_HONORAIRE) references TYPE_HONORAIRE (ID_TYPE_HONORAIRE)
)
    engine = InnoDB;

create table if not exists PROPRIETE
(
    ID_TIERS int             not null,
    ID_BIEN  int             not null,
    PART     int default 100 not null,
    primary key (ID_TIERS, ID_BIEN),
    constraint PROPRIETE_BIEN_ID_BIEN_fk
        foreign key (ID_BIEN) references BIEN (ID_BIEN),
    constraint PROPRIETE_TIERS_ID_TIERS_fk
        foreign key (ID_TIERS) references TIERS (ID_TIERS)
)
    engine = InnoDB;

create table if not exists SIGNATURE
(
    ID_SIGNATURE   int auto_increment
        primary key,
    TYPE_SIGNATURE varchar(1) null,
    DATE_SIGNATURE date       null,
    ID_BAIL        int        not null,
    ID_TIERS       int        not null,
    constraint SIGNATURE_BAIL_ID_BAIL_fk
        foreign key (ID_BAIL) references BAIL (ID_BAIL),
    constraint SIGNATURE_TIERS_ID_TIERS_fk
        foreign key (ID_TIERS) references TIERS (ID_TIERS)
)
    engine = InnoDB;

create definer = ilg@localhost trigger TIERS_BEFORE_INSERT
    before insert
    on TIERS
    for each row
BEGIN
SET NEW.NOM_TIERS = UPPER(NEW.NOm_TIERS);
END;

create definer = ilg@localhost trigger TIERS_BEFORE_UPDATE
    before update
    on TIERS
    for each row
BEGIN
SET NEW.NOM_TIERS = UPPER(NEW.NOm_TIERS);
END;

create definer = ilg@localhost trigger TYPE_TIERS_BEFORE_INSERT
    before insert
    on TYPE_TIERS
    for each row
BEGIN
SET NEW.LIB_TYPE_TIERS = UPPER(NEW.LIB_TYPE_TIERS);
END;

create definer = ilg@localhost trigger TYPE_TIERS_BEFORE_UPDATE
    before update
    on TYPE_TIERS
    for each row
BEGIN
SET NEW.LIB_TYPE_TIERS = UPPER(NEW.LIB_TYPE_TIERS);
END;

create
    definer = ilg@localhost procedure AjoutLocataire(IN P_ID_BAIL int, IN P_ID_LOCATAIRE int)
BEGIN
    DECLARE V_TYPE_TIERS VARCHAR(50) DEFAULT 0;
    SELECT TYPE_TIERS.LIB_TYPE_TIERS INTO V_TYPE_TIERS FROM TYPE_TIERS,TIERS
    WHERE TIERS.TYPE_TIERS= TYPE_TIERS.ID_TYPE_TIERS AND ID_TIERS=P_ID_LOCATAIRE;
    IF ( V_TYPE_TIERS = "LOCATAIRE") THEN
        INSERT INTO SIGNATURE(TYPE_SIGNATURE,ID_TIERS,ID_BAIL) VALUES ('L',P_ID_LOCATAIRE,P_ID_BAIL);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur - le tiers indiqué n est pas un locataire';
    end if;
end;

create
    definer = ilg@localhost function ControleProprietaireBail(P_ID_BAIL int, P_ID_PROPRIETAIRE int) returns tinyint(1)
    deterministic
BEGIN
    DECLARE V_RESULTAT BOOLEAN DEFAULT FALSE ;
    DECLARE V_BIEN INT DEFAULT 0;
    DECLARE V_NB_PROPRIETAIRES INT DEFAULT 0;
    SELECT ID_BIEN INTO V_BIEN FROM BAIL WHERE ID_BAIL = P_ID_BAIL;
    SELECT count(*) INTO V_NB_PROPRIETAIRES FROM PROPRIETE WHERE ID_TIERS= P_ID_PROPRIETAIRE AND ID_BIEN = V_BIEN;
    IF ( V_NB_PROPRIETAIRES  = 1 ) THEN
        SET V_RESULTAT = TRUE;
    end if;
    RETURN V_RESULTAT;
END;

create
    definer = ilg@localhost procedure CreationBail(IN P_ID_BIEN int, IN P_ID_AGENT int, IN P_DATE_EFFET date,
                                                   IN P_LOYER decimal(7, 2), IN P_IRL_BASE varchar(20),
                                                   IN P_IRL decimal(5, 2), IN P_CHARGES decimal(5, 2))
BEGIN
    DECLARE V_TYPE_TIERS VARCHAR(50) DEFAULT 0;
    DECLARE V_MOIS_RECONDUCTION INT DEFAULT 1;
    DECLARE V_DEPOT_GARANTIE DECIMAL(7,2) DEFAULT 0;
    DECLARE V_NB_BAIL INT DEFAULT 0;
    DECLARE V_ID_BAIL_PRECEDENT INT DEFAULT 0;
    DECLARE V_DATE_FIN_BAIL DATE;

    /* Il faut vérifier qu'il n'existe pas de bail avec une période de couverture commune avec celui qu'on va rechercher */
    /* c'est à dire que le dernier bail a bien une date de fin inférieure à la date d'effet */
        SELECT count(*) INTO V_NB_BAIL FROM BAIL WHERE ID_BIEN = P_ID_BIEN AND ETAT_BAIL <> 'TERMINE';

    IF (V_NB_BAIL > 0) THEN
        /* On a un bail en cours */
        SELECT ID_BAIL ,DATE_FIN_BAIL INTO V_ID_BAIL_PRECEDENT, V_DATE_FIN_BAIL
        FROM BAIL WHERE ID_BIEN = P_ID_BIEN AND ETAT_BAIL <> 'TERMINE';
        IF (V_DATE_FIN_BAIL > P_DATE_EFFET) THEN
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Erreur - il y a déjà un bail en cours sur cette période';
        end if;
    end if ;
    /* Vérification du type de tiers pour le tiers agent */
    SELECT TYPE_TIERS.LIB_TYPE_TIERS INTO V_TYPE_TIERS FROM TYPE_TIERS,TIERS
    WHERE TIERS.TYPE_TIERS= TYPE_TIERS.ID_TYPE_TIERS AND ID_TIERS=P_ID_AGENT;
    SET V_MOIS_RECONDUCTION = MONTH(P_DATE_EFFET);
    SET V_DEPOT_GARANTIE = 2 * P_LOYER;
    IF ( V_TYPE_TIERS = "AGENT IMMOBILIER") THEN
    INSERT INTO BAIL (ID_BIEN,ID_TIERS_AGENT,DATE_EFFET_BAIL,LOYER_INITIAL,IRL_BASE,VALEUR_IRL_BASE,MOIS_RECONDUCTION_BAIL,MONTANT_DEPOT_GARANTIE)
    VALUES (P_ID_BIEN,P_ID_AGENT,P_DATE_EFFET,P_LOYER,P_IRL_BASE,P_IRL,V_MOIS_RECONDUCTION,V_DEPOT_GARANTIE);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur - le tiers indiqué n est pas un agent immobilier';
    END IF;

end;

create
    definer = ilg@localhost procedure CreationHonorairesProprietaire(IN P_ID_BAIL int, IN P_ID_TIERS int, IN P_PART_TIERS int)
BEGIN
        DECLARE v_fin BOOLEAN DEFAULT FALSE;
        DECLARE v_id_type INT DEFAULT 0;
        DECLARE v_type VARCHAR(100);
        DECLARE v_paye_par VARCHAR(1) DEFAULT 'X';
        DECLARE v_type_tarif VARCHAR(100);
        DECLARE v_valeur_tarif DECIMAL(5,2);
        DECLARE v_montant_honoraire DECIMAL(5,2) DEFAULT 0;
        DECLARE v_curseur CURSOR FOR SELECT ID_TYPE_HONORAIRE,TYPE_HONORAIRE,PAYE_PAR,TYPE_TARIF,VALEUR_TARIF FROM TYPE_HONORAIRE WHERE PAYE_PAR='P';
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin = TRUE;

        /* Controle du proprietaire fourni */
IF ( ControleProprietaireBail(P_ID_BAIL,P_ID_TIERS)) THEN
        OPEN v_curseur;
        /* Balayage des honoraires dus par le prorpiétaire */
labelcurseur : LOOP
  FETCH v_curseur INTO v_id_type,v_type,v_paye_par,v_type_tarif,v_valeur_tarif;
  IF v_fin THEN
   LEAVE labelcurseur;
  END IF;
  IF (v_type_tarif = 'POURCENTAGE') THEN
      /* Il nous faut le montant du loyer pour calculer */
      SET v_montant_honoraire = (P_PART_TIERS /100 ) * LoyerBail(P_ID_BAIL) * v_valeur_tarif /100;
      INSERT INTO HONORAIRE(ID_TIERS,ID_TYPE_HONORAIRE,ID_BAIL,MONTANT_HONORAIRE)
          VALUES(P_ID_TIERS,v_id_type,P_ID_BAIL,v_montant_honoraire);
  end if;
  IF (v_type_tarif = 'CONSTANTE') THEN
      /* Il nous faut le nombre de pieces pour calculer l'honoraire */
      SET v_montant_honoraire = PiecesBail(P_ID_BAIL) * v_valeur_tarif;
      INSERT INTO HONORAIRE(ID_TIERS,ID_TYPE_HONORAIRE,ID_BAIL,MONTANT_HONORAIRE)
          VALUES(P_ID_TIERS,v_id_type,P_ID_BAIL,v_montant_honoraire);
  end if;
END LOOP labelcurseur;
CLOSE v_curseur;

ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur - le tiers indiqué n est pas un proprietaire associé au bail';
END IF;
 end;

create
    definer = ilg@localhost function LoyerBail(P_ID_BAIL int) returns decimal(5, 2) deterministic
BEGIN
    DECLARE V_RESULTAT DECIMAL(5,2) DEFAULT NULL ;
    SELECT LOYER_INITIAL INTO V_RESULTAT FROM BAIL WHERE ID_BAIL = P_ID_BAIL;
    RETURN V_RESULTAT;
END;

create
    definer = ilg@localhost function PiecesBail(P_ID_BAIL int) returns int deterministic
BEGIN
    DECLARE V_RESULTAT INT DEFAULT NULL ;
    DECLARE V_BIEN INT DEFAULT 0;
    SELECT ID_BIEN INTO V_BIEN FROM BAIL WHERE ID_BAIL = P_ID_BAIL;
    SELECT NOMBRE_PIECES INTO V_RESULTAT FROM BIEN WHERE ID_BIEN = V_BIEN;
    RETURN V_RESULTAT;
END;

create
    definer = ilg@localhost function estProprietaire(P_ID_TIERS int) returns tinyint(1) deterministic
BEGIN
    DECLARE V_TYPE_TIERS VARCHAR(50) DEFAULT 0;
    SELECT TYPE_TIERS.LIB_TYPE_TIERS INTO V_TYPE_TIERS FROM TYPE_TIERS,TIERS
    WHERE TIERS.TYPE_TIERS= TYPE_TIERS.ID_TYPE_TIERS AND ID_TIERS=P_ID_TIERS;
    IF ( V_TYPE_TIERS = "PROPRIETAIRE") THEN
        RETURN(TRUE);
    ELSE
        RETURN(FALSE);
    end if;
END;

