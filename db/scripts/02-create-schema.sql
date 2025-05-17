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
    contraseña VARCHAR(100) NOT NULL
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
    pedido_id_pedido INTEGER,
    UNIQUE (pedido_id_pedido),
    FOREIGN KEY (pedido_id_pedido) REFERENCES pedido(id_pedido)
);
ALTER TABLE pedido
ADD CONSTRAINT pedido_reporte_fk FOREIGN KEY (reporte_id_reporte) REFERENCES reporte(id_reporte);
ALTER TABLE reporte OWNER TO DB_USER;


CREATE TABLE detalle_pedido (
    id_detalle_pedido SERIAL PRIMARY KEY,
    cantidad INTEGER CHECK (cantidad > 0) NOT NULL,
    precio_unitario INTEGER NOT NULL,
    pedido_id_pedido INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    FOREIGN KEY (pedido_id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,
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


--Poblar tabla producto
INSERT INTO public.producto VALUES(1,'Aceite de coco','500ml',8300,100,'productos/aceitedecoco.png',1);
INSERT INTO public.producto VALUES(2,'Aceitunas verdes','100grs',800,100,'productos/aceitunasverdes.png',2);
INSERT INTO public.producto VALUES(3,'Aji de color','100grs',1000,100,'productos/ajidecolor.png',3);
INSERT INTO public.producto VALUES(4,'Aji Pimienta cayena','100grs',1600,100,'productos/ajipimienta.png',3);
INSERT INTO public.producto VALUES(5,'Ajos en escamas','100grs',1700,100,'productos/ajoenescamas.png',4);
INSERT INTO public.producto VALUES(6,'Ajo en polvo','100grs',900,100,'productos/ajoenpolvo.png',4);
INSERT INTO public.producto VALUES(7,'Aliño completo','100grs',900,100,'productos/aliñocompleto.png',5);
INSERT INTO public.producto VALUES(8,'Almendra entera','100grs',1500,100,'productos/almendraentera.png',6);

--Poblar tabla cliente
INSERT INTO public.cliente VALUES(1, 'Patricio', 'Finschi', 'patofinschi@gmail.com', 'pato2004');
INSERT INTO public.cliente VALUES(2, 'Cliente', 'Becs', 'becs.cliente@gmail.com', '1234567890');