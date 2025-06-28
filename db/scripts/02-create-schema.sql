\c DB_NAME

CREATE TABLE carrito (
    id_carrito SERIAL PRIMARY KEY,
    cliente_id_cliente INTEGER NOT NULL,
    fecha_carrito TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE carrito OWNER TO DB_USER;

CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(100) NOT NULL
);
ALTER TABLE categoria OWNER TO DB_USER;

CREATE TABLE rol (
    id_rol SERIAL PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL
);
ALTER TABLE rol OWNER TO DB_USER;

CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    contraseña VARCHAR(100) NOT NULL,
    direccion VARCHAR(200) NOT NULL
);
ALTER TABLE cliente OWNER TO DB_USER;

CREATE TABLE producto (
    id_producto SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(30) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    precio INTEGER NOT NULL,
    stock INTEGER CHECK (stock >= 0) NOT NULL,
    imagen VARCHAR(255) NOT NULL,
    id_categoria INTEGER NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) ON DELETE CASCADE
);
ALTER TABLE producto OWNER TO DB_USER;

CREATE TABLE detalle_carrito (
    id_detalle_carrito SERIAL PRIMARY KEY,
    cantidad INTEGER CHECK (cantidad > 0) NOT NULL,
    id_carrito INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    FOREIGN KEY (id_carrito) REFERENCES carrito(id_carrito) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE
);
ALTER TABLE detalle_carrito OWNER TO DB_USER;

CREATE TABLE estado_pedido (
    id_estado_pedido SERIAL PRIMARY KEY,
    estado VARCHAR(100) NOT NULL
);
ALTER TABLE estado_pedido OWNER TO DB_USER;

CREATE TABLE metodo_pago (
    id_metodo_pago SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(100) NOT NULL
);
ALTER TABLE metodo_pago OWNER TO DB_USER;

CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    cliente_id_cliente INTEGER NOT NULL,
    id_estado_pedido INTEGER NOT NULL,
    metodo_pago_id_metodo_pago INTEGER NOT NULL,
    transbank_transaction_date TIMESTAMP,
    transbank_state VARCHAR(50),
    transbank_pay_type VARCHAR(50),
    transbank_amount INTEGER,
    transbank_buy_order VARCHAR(50),
    reporte_id_reporte INTEGER,
    FOREIGN KEY (cliente_id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (id_estado_pedido) REFERENCES estado_pedido(id_estado_pedido),
    FOREIGN KEY (metodo_pago_id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago)
);
ALTER TABLE pedido OWNER TO DB_USER;

CREATE TABLE reporte (
    id_reporte SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    pedido_id_pedido INTEGER
);

ALTER TABLE reporte OWNER TO DB_USER;


CREATE TABLE detalle_pedido (
    id_detalle_pedido SERIAL PRIMARY KEY,
    cantidad INTEGER CHECK (cantidad > 0) NOT NULL,
    precio_unitario INTEGER NOT NULL,
    pedido_id_pedido INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE
);
ALTER TABLE detalle_pedido OWNER TO DB_USER;

CREATE TABLE inventario (
    id_mov SERIAL PRIMARY KEY,
    cantidad INTEGER NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    motivo VARCHAR(100) NOT NULL,
    id_producto INTEGER NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE
);
ALTER TABLE inventario OWNER TO DB_USER;

CREATE TABLE valoracion_cliente (
    id_valoracion_cliente SERIAL PRIMARY KEY,
    valoracion VARCHAR(1) CHECK (valoracion BETWEEN '1' AND '5'),
    nombre VARCHAR(40),
    comentario VARCHAR(100),
    cliente_id_cliente INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    FOREIGN KEY (cliente_id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE
);
ALTER TABLE valoracion_cliente OWNER TO DB_USER;

CREATE TABLE auth_group (
  id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL UNIQUE
);
ALTER TABLE auth_group OWNER TO DB_USER;


CREATE TABLE django_content_type (
  id SERIAL PRIMARY KEY,
  app_label VARCHAR(100) NOT NULL,
  model VARCHAR(100) NOT NULL,
  CONSTRAINT django_content_type_app_label_model_uniq UNIQUE (app_label, model)
);
ALTER TABLE django_content_type OWNER TO DB_USER;

CREATE TABLE auth_user (
  id SERIAL PRIMARY KEY,
  password VARCHAR(128) NOT NULL,
  last_login TIMESTAMP(6),
  is_superuser BOOLEAN NOT NULL,
  username VARCHAR(150) NOT NULL UNIQUE,
  first_name VARCHAR(150) NOT NULL,
  last_name VARCHAR(150) NOT NULL,
  email VARCHAR(254) NOT NULL,
  is_staff BOOLEAN NOT NULL,
  is_active BOOLEAN NOT NULL,
  date_joined TIMESTAMP(6) NOT NULL
);
ALTER TABLE auth_user OWNER TO DB_USER;

CREATE TABLE django_migrations (
  id SERIAL PRIMARY KEY,
  app VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  applied TIMESTAMP(6) NOT NULL
);
ALTER TABLE django_migrations OWNER TO DB_USER;

CREATE TABLE django_session (
  session_key VARCHAR(40) PRIMARY KEY,
  session_data TEXT NOT NULL,
  expire_date TIMESTAMP(6) NOT NULL
);
CREATE INDEX django_session_expire_date_idx ON django_session(expire_date);
ALTER TABLE django_session OWNER TO DB_USER;

CREATE TABLE auth_permission (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  content_type_id INTEGER NOT NULL,
  codename VARCHAR(100) NOT NULL,
  CONSTRAINT auth_permission_content_type_id_codename_uniq UNIQUE (content_type_id, codename),
  CONSTRAINT auth_permission_content_type_id_fk FOREIGN KEY (content_type_id) REFERENCES django_content_type(id)
);
ALTER TABLE auth_permission OWNER TO DB_USER;

CREATE TABLE auth_group_permissions (
  id SERIAL PRIMARY KEY,
  group_id INTEGER NOT NULL,
  permission_id INTEGER NOT NULL,
  CONSTRAINT auth_group_permissions_group_id_permission_id_uniq UNIQUE (group_id, permission_id),
  FOREIGN KEY (group_id) REFERENCES auth_group(id),
  FOREIGN KEY (permission_id) REFERENCES auth_permission(id)
);
ALTER TABLE auth_group_permissions OWNER TO DB_USER;

CREATE TABLE auth_user_groups (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  group_id INTEGER NOT NULL,
  CONSTRAINT auth_user_groups_user_id_group_id_uniq UNIQUE (user_id, group_id),
  FOREIGN KEY (user_id) REFERENCES auth_user(id),
  FOREIGN KEY (group_id) REFERENCES auth_group(id)
);
ALTER TABLE auth_user_groups OWNER TO DB_USER;

CREATE TABLE auth_user_user_permissions (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  permission_id INTEGER NOT NULL,
  CONSTRAINT auth_user_user_permissions_user_id_permission_id_uniq UNIQUE (user_id, permission_id),
  FOREIGN KEY (user_id) REFERENCES auth_user(id),
  FOREIGN KEY (permission_id) REFERENCES auth_permission(id)
);
ALTER TABLE auth_user_user_permissions OWNER TO DB_USER;

CREATE TABLE django_admin_log (
  id SERIAL PRIMARY KEY,
  action_time TIMESTAMP(6) NOT NULL,
  object_id TEXT,
  object_repr VARCHAR(200) NOT NULL,
  action_flag SMALLINT CHECK (action_flag >= 0) NOT NULL,
  change_message TEXT NOT NULL,
  content_type_id INTEGER,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (content_type_id) REFERENCES django_content_type(id),
  FOREIGN KEY (user_id) REFERENCES auth_user(id)
);
ALTER TABLE django_admin_log OWNER TO DB_USER;


INSERT INTO public.auth_user VALUES (1, 'pbkdf2_sha256$1000000$xlXvjz0ddDJxRhURoywfyQ$3fpn+aT2y83o3ARN6A/Drq2VYuHf9siYnaAeEqfCZ40=', '2025-05-03 23:52:03.627244', true, 'admin', '', '', 'admin@admin.cl', true, true, '2025-05-03 23:51:39.405479');
INSERT INTO public.auth_user VALUES (2, 'pbkdf2_sha256$1000000$nUOVj2WuTpGokiDWob07Gm$E0qx6OkRjs61AqSSP+M0IaChjLnxHKpBZLUycHQ3vr0=', '2025-05-17 23:52:03.629496', true, 'BescsUser', '', '', 'becs@admin.cl', true, true, '2025-05-17 23:51:39.405479');

INSERT INTO public.django_session VALUES ('d1uvsdghd772q8qhbsxftggl6i7rjiin', '.eJxVjMsOgjAUBf-la9P0CcWle76h6X1gUdMmFFbGfxcSFro9M3PeIqZtzXFrvMSZxFVocfndIOGTywHokcq9SqxlXWaQhyJP2uRYiV-30_07yKnlvUZNDr1i431PWk8eePABg2VW1iF11iVPaULXhQF6Cko7AEu7bYDRiM8X7HY4XA:1uBMeJ:EnEMc_h-NIy2S976iwMh6CIEYbJd3DwkhLB7MEs0URg', '2025-05-17 23:52:03.629496');


--Poblar tabla categoria
INSERT INTO public.categoria VALUES(1, 'Aceites', 'Aceites');
INSERT INTO public.categoria VALUES(2, 'Aceitunas', 'Aceitunas');
INSERT INTO public.categoria VALUES(3, 'Aji', 'Aji');
INSERT INTO public.categoria VALUES(4, 'Ajos', 'Ajos');
INSERT INTO public.categoria VALUES(5, 'Aliño', 'Aliño');
INSERT INTO public.categoria VALUES(6, 'Almendras', 'Almendras');
INSERT INTO public.categoria VALUES(7, 'Avellanas', 'Avellanas');
INSERT INTO public.categoria VALUES(8, 'Dátiles', 'Dátiles');
INSERT INTO public.categoria VALUES(9, 'Higos', 'Higos');
INSERT INTO public.categoria VALUES(10, 'Nueces', 'Nueces');
INSERT INTO public.categoria VALUES(11, 'Maní', 'Maní');
INSERT INTO public.categoria VALUES(12, 'Granola', 'Granola');
INSERT INTO public.categoria VALUES(13, 'Sales', 'Sales');
INSERT INTO public.categoria VALUES(14, 'Frutas deshidratadas', 'Frutas deshidratadas');
INSERT INTO public.categoria VALUES(15, 'Chocolate', 'Chocolate');
INSERT INTO public.categoria VALUES(16, 'Especias', 'Especias');
INSERT INTO public.categoria VALUES(17, 'Quinoa', 'Quinoa');
INSERT INTO public.categoria VALUES(18, 'Semillas', 'Semillas');
INSERT INTO public.categoria VALUES(19, 'Pistachos', 'Pistachos');
INSERT INTO public.categoria VALUES(20, 'Pasas', 'Pasas');
INSERT INTO public.categoria VALUES(21, 'Cereales', 'Cereales');
INSERT INTO public.categoria VALUES(22, 'Harinas', 'Harinas');
INSERT INTO public.categoria VALUES(23, 'Miel', 'Miel');
INSERT INTO public.categoria VALUES(24, 'Tés', 'Tés');
INSERT INTO public.categoria VALUES(25, 'Condimentos', 'Condimentos');
INSERT INTO public.categoria VALUES(26, 'Alfajor', 'Alfajor');


--Poblar tabla producto
-- ACEITES (Categoría 1)
INSERT INTO public.producto VALUES(1,'Aceite de coco','500ml',8300,100,'productos/aceitedecoco.png',1);

-- ACEITUNAS (Categoría 2)
INSERT INTO public.producto VALUES(2,'Aceitunas verdes','100grs',800,100,'productos/aceitunasverdes.png',2);

-- AJÍ (Categoría 3)
INSERT INTO public.producto VALUES(3,'Aji de color','100grs',1000,100,'productos/ajidecolor.png',3);
INSERT INTO public.producto VALUES(4,'Aji Pimienta cayena','100grs',1600,100,'productos/ajipimienta.png',3);

-- AJOS (Categoría 4)
INSERT INTO public.producto VALUES(5,'Ajos en escamas','100grs',1700,100,'productos/ajoenescamas.png',4);
INSERT INTO public.producto VALUES(6,'Ajo en polvo','100grs',900,100,'productos/ajoenpolvo.png',4);

-- ALIÑOS (Categoría 5)
INSERT INTO public.producto VALUES(7,'Aliño completo','100grs',900,100,'productos/aliñocompleto.png',5);

-- ALMENDRAS (Categoría 6)
INSERT INTO public.producto VALUES(8,'Almendra entera','100grs',1500,100,'productos/almendraentera.png',6);


-- AVELLANAS (Categoría 7)
INSERT INTO public.producto VALUES(9,'Avellanas Europeas con Choc','100grs',2200,100,'productos/Avellana_con_chocolate.jpg',7);
INSERT INTO public.producto VALUES(10,'Avellanas Europeas Tostadas','100grs',2400,100,'productos/Avellana_tostada_europea.jpg',7);

-- DÁTILES (Categoría 8)
INSERT INTO public.producto VALUES(11,'Dátiles','100grs',750,100,'productos/Datiles.jpg',8);

-- HIGOS (Categoría 9)
INSERT INTO public.producto VALUES(12,'Higos Deshidratados','100grs',950,100,'productos/Higos_deshidratados.jpg',9);

-- NUECES (Categoría 10)
INSERT INTO public.producto VALUES(13,'Nuez Mariposa Chandler','100grs',1200,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',10);
INSERT INTO public.producto VALUES(14,'Nuez moscada en polvo','50grs',1400,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',10);
INSERT INTO public.producto VALUES(15,'Nuez moscada entera','C/U',350,100,'productos/nuez_moscada_entera.jpg',10);

-- MANÍ (Categoría 11)
INSERT INTO public.producto VALUES(16,'Maní Choc de colores','100grs',750,100,'productos/mani_choc_de_colores_2.jpg',11);
INSERT INTO public.producto VALUES(17,'Maní Confitado coco miel','100grs',600,100,'productos/Mani_coco_miel2.jpg',11);
INSERT INTO public.producto VALUES(18,'Maní Confitado frutilla','100grs',600,100,'productos/Mani_frutilla_2.jpg',11);
INSERT INTO public.producto VALUES(19,'Maní Confitado Menta','100grs',600,100,'productos/mani_menta_2.jpg',11);
INSERT INTO public.producto VALUES(20,'Maní Confitado Mora','100grs',600,100,'productos/mani_mora_crema.jpg',11);
INSERT INTO public.producto VALUES(21,'Maní Confitado Naranja','100grs',600,100,'productos/Mani_Naranja.jpg',11);
INSERT INTO public.producto VALUES(22,'Maní Confitado Pisco Sour','100grs',600,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',11);
INSERT INTO public.producto VALUES(23,'Maní Confitado Pistacho','100grs',600,100,'productos/mani_choc_de_colores_2.jpg',11);
INSERT INTO public.producto VALUES(24,'Maní Confitado Platano','100grs',600,100,'productos/mani_choc_de_colores_2.jpg',11);
INSERT INTO public.producto VALUES(25,'Maní Japones','100grs',950,100,'productos/Mani_japones_2.jpg',11);
INSERT INTO public.producto VALUES(26,'Maní Japones Merken','100grs',950,100,'productos/Mani_Japones_merken_2.jpg',11);
INSERT INTO public.producto VALUES(27,'Maní Salado Merkén','100grs',700,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',11);
INSERT INTO public.producto VALUES(28,'Maní Salado Tostado','100grs',700,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',11);
INSERT INTO public.producto VALUES(29,'Mani sin sal','100grs',750,100,'productos/Mani_sin_sal.jpg',11);
INSERT INTO public.producto VALUES(30,'Mani Confitado tres leches','100grs',750,100,'productos/Mani_tres_leches.jpg',11);

-- GRANOLA (Categoría 12)
INSERT INTO public.producto VALUES(31,'Granola','100grs',600,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',12);
INSERT INTO public.producto VALUES(32,'Granola miel','100grs',600,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',12);

-- SALES (Categoría 13)
INSERT INTO public.producto VALUES(33,'Sal rosada','100grs',460,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',13);
INSERT INTO public.producto VALUES(34,'Sal rosada fina','100grs',460,100,'productos/Sal_rosada_fina.jpg',13);


-- CHOCOLATE (Categoría 15)
INSERT INTO public.producto VALUES(35,'Monedas de chocolate','100grs',1000,100,'productos/Chips_de_chocolate_2.jpg',15);

-- QUINOA (Categoría 17)
INSERT INTO public.producto VALUES(36,'Quinoa blanca','1/2 Kilo',3500,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',17);
INSERT INTO public.producto VALUES(37,'Quinoa Pop Dulce','100grs',900,100,'productos/Quinoa_pop_endulzada.jpg',17);

-- SEMILLAS (Categoría 18)
INSERT INTO public.producto VALUES(38,'Semillas de zapallo','100grs',950,100,'productos/Semilla_de_zapallo.jpg',18);
INSERT INTO public.producto VALUES(39,'Semillas de amapola','100grs',950,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',18);

-- PISTACHOS (Categoría 19)
INSERT INTO public.producto VALUES(40,'Pistacho','100grs',2100,100,'productos/Pistacho.jpg',19);

-- PASAS (Categoría 20)
INSERT INTO public.producto VALUES(41,'Pasas rubias','100grs',900,100,'productos/Pasas_rubias.jpg',20);
INSERT INTO public.producto VALUES(42,'Pasas de chocolate','100grs',800,100,'productos/Pasas_con_chocolate_2.jpg',20);

-- HARINAS (Categoría 22)
INSERT INTO public.producto VALUES(43,'Harina Blanca','1 kilo',1400,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',22);
INSERT INTO public.producto VALUES(44,'Harina de Almendra Sin Piel','1/2 Kilo',7000,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',22);
INSERT INTO public.producto VALUES(45,'Harina de Arroz','1 kilo',2500,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',22);
INSERT INTO public.producto VALUES(46,'Harina de Avena','1 kilo',2500,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',22);
INSERT INTO public.producto VALUES(47,'Harina de Garbanzo','1 kilo',3500,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',22);
INSERT INTO public.producto VALUES(48,'Harina de Linaza','1 kilo',4500,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',22);
INSERT INTO public.producto VALUES(49,'Harina Integral','1 kilo',1800,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',22);
INSERT INTO public.producto VALUES(50,'Harina Pan','1 kilo',1800,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',22);
INSERT INTO public.producto VALUES(51,'Harina tostada','1 kilo',2500,100,'productos/Harina_tostada.jpg',22);
INSERT INTO public.producto VALUES(52,'Harina de coco','1 kilo',6000,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',22);

-- MIEL (Categoría 23)
INSERT INTO public.producto VALUES(53,'Miel de Ulmo Eucalipto','1 kilo',6000,100,'productos/Mieles.jpg',23);
INSERT INTO public.producto VALUES(54,'Miel de Ulmo Flores Pectorales','1 kilo',6000,100,'productos/Mieles_2.jpg',23);
INSERT INTO public.producto VALUES(55,'Miel de Ulmo Jengibre Limon','1 kilo',6000,100,'productos/Mieles.jpg',23);
INSERT INTO public.producto VALUES(56,'Miel de Ulmo Liquido y Solido','1 kilo',5000,100,'productos/Mieles.jpg',23);
INSERT INTO public.producto VALUES(57,'Miel de Ulmo Palto Miel','250grs',6000,100,'productos/Mieles.jpg',23);

-- TÉS (Categoría 24)
INSERT INTO public.producto VALUES(58,'Té blanco','50grs',1500,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',24);

-- CONDIMENTOS (Categoría 25)
INSERT INTO public.producto VALUES(59,'Orégano','100grs',900,100,'productos/Oregano.jpg',25);
INSERT INTO public.producto VALUES(60,'Romero','50grs',1500,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',25);
INSERT INTO public.producto VALUES(61,'Laurel','50grs',1500,100,'productos/Laurel.jpg',25);
INSERT INTO public.producto VALUES(62,'Perejil','50grs',350,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',25);

-- ALFAJOR (Categoría 26)
INSERT INTO public.producto VALUES(63,'Alfajor Dulce de leche','C/U',1200,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',26);
INSERT INTO public.producto VALUES(64,'Alfajor Dulce de leche(Srt)','2-uni',2000,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',26);
INSERT INTO public.producto VALUES(65,'Alfajor Dulce de leche(Fram)','C/U',1200,100,'productos/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not.jpg',26);


--Poblar tabla cliente
INSERT INTO public.cliente VALUES(1, 'Patricio', 'Finschi', 'patofinschi@gmail.com', 'pato2004', '123 Main St');
INSERT INTO public.cliente VALUES(2, 'Cliente', 'Becs', 'becs.cliente@gmail.com', '1234567890', '456 Elm St');

--Poblar tabla metodo_pago
INSERT INTO public.metodo_pago VALUES(1, 'Transbank', 'Pago con tarjeta via Transbank');
INSERT INTO public.metodo_pago VALUES(2, 'Transferencia', 'Pago por transferencia bancaria');

--Poblar tabla estado_pedido
INSERT INTO public.estado_pedido VALUES(1, 'Pagado');
INSERT INTO public.estado_pedido VALUES(2, 'Terminado');

--Poblar tabla pedido
INSERT INTO public.pedido VALUES(1, '2021-04-16 10:00:00', 1, 1, 1, '2021-01-10 10:00:00', 'ACEPTADO', 'Tarjeta de Débito', 12000, 'ORD1001', NULL);
INSERT INTO public.pedido VALUES(2, '2024-05-18 11:30:00', 2, 1, 2, '2025-06-27 11:30:00', 'ACEPTADO', 'Tarjeta de Crédito', 18500, 'ORD1002', NULL);
INSERT INTO public.pedido VALUES(3, '2025-06-27 12:45:00', 1, 1, 1, '2025-03-29 12:45:00', 'ACEPTADO', 'Tarjeta de Débito', 9500, 'ORD1003', NULL);
INSERT INTO public.pedido VALUES(4, '2025-03-15 13:20:00', 2, 1, 2, '2024-05-18 13:20:00', 'ACEPTADO', 'Tarjeta de Crédito', 21000, 'ORD1004', NULL);
INSERT INTO public.pedido VALUES(5, '2023-04-19 14:10:00', 1, 1, 1, '2023-09-15 14:10:00', 'ACEPTADO', 'Tarjeta de Débito', 17500, 'ORD1005', NULL);
INSERT INTO public.pedido VALUES(6, '2024-05-18 15:00:00', 2, 1, 2, '2025-04-23 15:00:00', 'ACEPTADO', 'Tarjeta de Crédito', 9900, 'ORD1006', NULL);

--Poblar tabla detalle_pedido
INSERT INTO public.detalle_pedido VALUES(1, 2, 8300, 1, 1); -- Pedido 1, 2x Aceite de coco
INSERT INTO public.detalle_pedido VALUES(2, 1, 800, 1, 2);  -- Pedido 1, 1x Aceitunas verdes
INSERT INTO public.detalle_pedido VALUES(3, 3, 1000, 2, 3); -- Pedido 2, 3x Aji de color
INSERT INTO public.detalle_pedido VALUES(4, 1, 1700, 2, 5); -- Pedido 2, 1x Ajos en escamas
INSERT INTO public.detalle_pedido VALUES(5, 2, 1500, 3, 8); -- Pedido 3, 2x Almendra entera
INSERT INTO public.detalle_pedido VALUES(6, 1, 900, 3, 6);  -- Pedido 3, 1x Ajo en polvo
INSERT INTO public.detalle_pedido VALUES(7, 1, 900, 4, 7);  -- Pedido 4, 1x Aliño completo
INSERT INTO public.detalle_pedido VALUES(8, 2, 800, 4, 2);  -- Pedido 4, 2x Aceitunas verdes
INSERT INTO public.detalle_pedido VALUES(9, 1, 8300, 5, 1); -- Pedido 5, 1x Aceite de coco
INSERT INTO public.detalle_pedido VALUES(10, 2, 1000, 5, 3);-- Pedido 5, 2x Aji de color
INSERT INTO public.detalle_pedido VALUES(11, 1, 1500, 6, 8);-- Pedido 6, 1x Almendra entera
INSERT INTO public.detalle_pedido VALUES(12, 1, 900, 6, 7); -- Pedido 6, 1x Aliño completo
-- Fin poblar tabla detalle_pedido

-- AL FINAL DEL ARCHIVO, SINCRONIZACIÓN DE SECUENCIAS
-- Esto asegura que los contadores de ID de PostgreSQL estén alineados con los datos insertados manualmente.

SELECT setval('categoria_id_categoria_seq', COALESCE((SELECT MAX(id_categoria) FROM categoria), 1), true);
SELECT setval('producto_id_producto_seq', COALESCE((SELECT MAX(id_producto) FROM producto), 1), true);
SELECT setval('cliente_id_cliente_seq', COALESCE((SELECT MAX(id_cliente) FROM cliente), 1), true);
SELECT setval('rol_id_rol_seq', COALESCE((SELECT MAX(id_rol) FROM rol), 1), true);
SELECT setval('estado_pedido_id_estado_pedido_seq', COALESCE((SELECT MAX(id_estado_pedido) FROM estado_pedido), 1), true);
SELECT setval('metodo_pago_id_metodo_pago_seq', COALESCE((SELECT MAX(id_metodo_pago) FROM metodo_pago), 1), true);
SELECT setval('pedido_id_pedido_seq', COALESCE((SELECT MAX(id_pedido) FROM pedido), 1), true);
SELECT setval('detalle_pedido_id_detalle_pedido_seq', COALESCE((SELECT MAX(id_detalle_pedido) FROM detalle_pedido), 1), true);