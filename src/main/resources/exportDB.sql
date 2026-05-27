--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4 (Debian 12.4-1.pgdg100+1)
-- Dumped by pg_dump version 13.2

-- Started on 2026-05-26 22:30:23 -05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 667 (class 1247 OID 16795)
-- Name: product_status; Type: TYPE; Schema: public; Owner: ground
--

CREATE TYPE public.product_status AS ENUM (
    'available'
);


ALTER TYPE public.product_status OWNER TO ground;

--
-- TOC entry 631 (class 1247 OID 17144)
-- Name: productstatus; Type: TYPE; Schema: public; Owner: ground
--

CREATE TYPE public.productstatus AS ENUM (
    'available',
    'out_of_stock',
    'discontinued'
);


ALTER TYPE public.productstatus OWNER TO ground;

--
-- TOC entry 663 (class 1247 OID 16748)
-- Name: user_status; Type: TYPE; Schema: public; Owner: ground
--

CREATE TYPE public.user_status AS ENUM (
    'active'
);


ALTER TYPE public.user_status OWNER TO ground;

--
-- TOC entry 634 (class 1247 OID 17154)
-- Name: userstatus; Type: TYPE; Schema: public; Owner: ground
--

CREATE TYPE public.userstatus AS ENUM (
    'active',
    'inactive',
    'suspended'
);


ALTER TYPE public.userstatus OWNER TO ground;

--
-- TOC entry 2824 (class 2605 OID 17152)
-- Name: CAST (public.productstatus AS character varying); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (public.productstatus AS character varying) WITH INOUT AS IMPLICIT;


--
-- TOC entry 2825 (class 2605 OID 17162)
-- Name: CAST (public.userstatus AS character varying); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (public.userstatus AS character varying) WITH INOUT AS IMPLICIT;


--
-- TOC entry 2747 (class 2605 OID 17151)
-- Name: CAST (character varying AS public.productstatus); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (character varying AS public.productstatus) WITH INOUT AS IMPLICIT;


--
-- TOC entry 2748 (class 2605 OID 17161)
-- Name: CAST (character varying AS public.userstatus); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (character varying AS public.userstatus) WITH INOUT AS IMPLICIT;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 203 (class 1259 OID 16581)
-- Name: historical_chats; Type: TABLE; Schema: public; Owner: ground
--

CREATE TABLE public.historical_chats (
    id_chat bigint NOT NULL,
    content text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    id_user bigint NOT NULL
);


ALTER TABLE public.historical_chats OWNER TO ground;

--
-- TOC entry 202 (class 1259 OID 16579)
-- Name: historical_chats_id_chat_seq; Type: SEQUENCE; Schema: public; Owner: ground
--

CREATE SEQUENCE public.historical_chats_id_chat_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.historical_chats_id_chat_seq OWNER TO ground;

--
-- TOC entry 2995 (class 0 OID 0)
-- Dependencies: 202
-- Name: historical_chats_id_chat_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ground
--

ALTER SEQUENCE public.historical_chats_id_chat_seq OWNED BY public.historical_chats.id_chat;


--
-- TOC entry 206 (class 1259 OID 16612)
-- Name: products; Type: TABLE; Schema: public; Owner: ground
--

CREATE TABLE public.products (
    id_product bigint NOT NULL,
    name character varying(150) NOT NULL,
    price numeric(10,2),
    stock_quantity integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status public.product_status,
    created_by bigint
);


ALTER TABLE public.products OWNER TO ground;

--
-- TOC entry 212 (class 1259 OID 16817)
-- Name: products_id_product_seq; Type: SEQUENCE; Schema: public; Owner: ground
--

CREATE SEQUENCE public.products_id_product_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_product_seq OWNER TO ground;

--
-- TOC entry 2998 (class 0 OID 0)
-- Dependencies: 212
-- Name: products_id_product_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ground
--

ALTER SEQUENCE public.products_id_product_seq OWNED BY public.products.id_product;


--
-- TOC entry 207 (class 1259 OID 16620)
-- Name: products_sales; Type: TABLE; Schema: public; Owner: ground
--

CREATE TABLE public.products_sales (
    id_sale bigint NOT NULL,
    id_product bigint NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL
);


ALTER TABLE public.products_sales OWNER TO ground;

--
-- TOC entry 208 (class 1259 OID 16625)
-- Name: roles; Type: TABLE; Schema: public; Owner: ground
--

CREATE TABLE public.roles (
    id_role bigint NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.roles OWNER TO ground;

--
-- TOC entry 209 (class 1259 OID 16630)
-- Name: sales; Type: TABLE; Schema: public; Owner: ground
--

CREATE TABLE public.sales (
    id_sale bigint NOT NULL,
    id_user bigint,
    bill_number character varying(100),
    total_bill numeric(12,2),
    created_at timestamp without time zone
);


ALTER TABLE public.sales OWNER TO ground;

--
-- TOC entry 210 (class 1259 OID 16635)
-- Name: users; Type: TABLE; Schema: public; Owner: ground
--

CREATE TABLE public.users (
    id_user bigint NOT NULL,
    email character varying(50),
    password character varying(255) NOT NULL,
    document_type character varying(50),
    document_number character varying(50),
    name character varying(150) NOT NULL,
    id_role bigint,
    last_connection timestamp without time zone,
    status public.user_status
);


ALTER TABLE public.users OWNER TO ground;

--
-- TOC entry 211 (class 1259 OID 16791)
-- Name: users_id_user_seq; Type: SEQUENCE; Schema: public; Owner: ground
--

CREATE SEQUENCE public.users_id_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_user_seq OWNER TO ground;

--
-- TOC entry 3004 (class 0 OID 0)
-- Dependencies: 211
-- Name: users_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ground
--

ALTER SEQUENCE public.users_id_user_seq OWNED BY public.users.id_user;


--
-- TOC entry 205 (class 1259 OID 16592)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: ground
--

CREATE TABLE public.usuarios (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE public.usuarios OWNER TO ground;

--
-- TOC entry 204 (class 1259 OID 16590)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: ground
--

CREATE SEQUENCE public.usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuarios_id_seq OWNER TO ground;

--
-- TOC entry 3007 (class 0 OID 0)
-- Dependencies: 204
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ground
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 2826 (class 2604 OID 16584)
-- Name: historical_chats id_chat; Type: DEFAULT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.historical_chats ALTER COLUMN id_chat SET DEFAULT nextval('public.historical_chats_id_chat_seq'::regclass);


--
-- TOC entry 2828 (class 2604 OID 16819)
-- Name: products id_product; Type: DEFAULT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.products ALTER COLUMN id_product SET DEFAULT nextval('public.products_id_product_seq'::regclass);


--
-- TOC entry 2829 (class 2604 OID 16793)
-- Name: users id_user; Type: DEFAULT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.users ALTER COLUMN id_user SET DEFAULT nextval('public.users_id_user_seq'::regclass);


--
-- TOC entry 2827 (class 2604 OID 16595)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 2979 (class 0 OID 16581)
-- Dependencies: 203
-- Data for Name: historical_chats; Type: TABLE DATA; Schema: public; Owner: ground
--

COPY public.historical_chats (id_chat, content, created_at, id_user) FROM stdin;
1	Hola esto es una prueba	2026-05-21 19:14:56.622328	1
2	No sirve	2026-05-21 19:17:34.33249	2
3	no llego aca	2026-05-21 19:22:07.657303	2
4	no me llega la data	2026-05-21 19:33:09.639012	2
5	ahora	2026-05-21 19:40:18.766129	2
6	desde la web	2026-05-21 19:45:19.406328	2
7	no llega mensaje	2026-05-21 19:49:49.067362	2
8	gjk	2026-05-21 19:55:19.232414	2
9	hyuui	2026-05-21 19:59:57.614974	2
10	test desde la app	2026-05-21 22:52:57.357555	1
11	app	2026-05-21 22:58:09.252427	1
12	Hola desde la app	2026-05-21 23:03:39.946499	1
13	hola desde la web	2026-05-21 23:03:48.558548	2
14	App	2026-05-21 23:10:17.658696	1
15	Web	2026-05-21 23:10:22.550717	2
\.


--
-- TOC entry 2982 (class 0 OID 16612)
-- Dependencies: 206
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: ground
--

COPY public.products (id_product, name, price, stock_quantity, created_at, updated_at, status, created_by) FROM stdin;
4	Vasos desechables	200.99	100	2026-05-21 20:14:45.544751	\N	available	1
5	Jabon	500.00	\N	2026-05-21 23:02:45.096257	\N	available	1
6	Papel reciclable	10.99	90	2026-05-21 23:05:00.204594	\N	available	1
\.


--
-- TOC entry 2983 (class 0 OID 16620)
-- Dependencies: 207
-- Data for Name: products_sales; Type: TABLE DATA; Schema: public; Owner: ground
--

COPY public.products_sales (id_sale, id_product, quantity, unit_price) FROM stdin;
\.


--
-- TOC entry 2984 (class 0 OID 16625)
-- Dependencies: 208
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: ground
--

COPY public.roles (id_role, name) FROM stdin;
1	Admin
2	Cliente
3	Vendedor
\.


--
-- TOC entry 2985 (class 0 OID 16630)
-- Dependencies: 209
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: ground
--

COPY public.sales (id_sale, id_user, bill_number, total_bill, created_at) FROM stdin;
\.


--
-- TOC entry 2986 (class 0 OID 16635)
-- Dependencies: 210
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: ground
--

COPY public.users (id_user, email, password, document_type, document_number, name, id_role, last_connection, status) FROM stdin;
1	Jorge@example.com	$2a$10$OUod9KIJK/XoMt1N4FihE.LmFDw4.AXulTmEKaOFNlmK3tsvIareq	\N	1047963258	Jorge Castro	1	\N	active
2	Jeronimo@example.com	$2a$10$r1BwjZltNhKFs5IaZejfM.ORBhF93.Gr.8D0rNOJT5zC.4FDxPy12	\N	1033242413	Jeronimo Oliver	1	\N	active
\.


--
-- TOC entry 2981 (class 0 OID 16592)
-- Dependencies: 205
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: ground
--

COPY public.usuarios (id, email, nombre) FROM stdin;
\.


--
-- TOC entry 3009 (class 0 OID 0)
-- Dependencies: 202
-- Name: historical_chats_id_chat_seq; Type: SEQUENCE SET; Schema: public; Owner: ground
--

SELECT pg_catalog.setval('public.historical_chats_id_chat_seq', 15, true);


--
-- TOC entry 3010 (class 0 OID 0)
-- Dependencies: 212
-- Name: products_id_product_seq; Type: SEQUENCE SET; Schema: public; Owner: ground
--

SELECT pg_catalog.setval('public.products_id_product_seq', 6, true);


--
-- TOC entry 3011 (class 0 OID 0)
-- Dependencies: 211
-- Name: users_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: ground
--

SELECT pg_catalog.setval('public.users_id_user_seq', 2, true);


--
-- TOC entry 3012 (class 0 OID 0)
-- Dependencies: 204
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ground
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 1, false);


--
-- TOC entry 2831 (class 2606 OID 16589)
-- Name: historical_chats historical_chats_pkey; Type: CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.historical_chats
    ADD CONSTRAINT historical_chats_pkey PRIMARY KEY (id_chat);


--
-- TOC entry 2837 (class 2606 OID 16619)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id_product);


--
-- TOC entry 2839 (class 2606 OID 16624)
-- Name: products_sales products_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.products_sales
    ADD CONSTRAINT products_sales_pkey PRIMARY KEY (id_sale, id_product);


--
-- TOC entry 2841 (class 2606 OID 16629)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id_role);


--
-- TOC entry 2843 (class 2606 OID 16634)
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id_sale);


--
-- TOC entry 2833 (class 2606 OID 16599)
-- Name: usuarios uk_kfsp0s1tflm1cwlj8idhqsad0; Type: CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT uk_kfsp0s1tflm1cwlj8idhqsad0 UNIQUE (email);


--
-- TOC entry 2845 (class 2606 OID 16642)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);


--
-- TOC entry 2835 (class 2606 OID 16597)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 2846 (class 2606 OID 16683)
-- Name: historical_chats fkgpue7wt8n7uf1dk8fdygx1mba; Type: FK CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.historical_chats
    ADD CONSTRAINT fkgpue7wt8n7uf1dk8fdygx1mba FOREIGN KEY (id_user) REFERENCES public.users(id_user);


--
-- TOC entry 2847 (class 2606 OID 16879)
-- Name: products fkl0lce8i162ldn9n01t2a6lcix; Type: FK CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fkl0lce8i162ldn9n01t2a6lcix FOREIGN KEY (created_by) REFERENCES public.users(id_user);


--
-- TOC entry 2848 (class 2606 OID 16643)
-- Name: products_sales products_sales_id_product_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.products_sales
    ADD CONSTRAINT products_sales_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.products(id_product) NOT VALID;


--
-- TOC entry 2849 (class 2606 OID 16648)
-- Name: products_sales products_sales_id_sale_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.products_sales
    ADD CONSTRAINT products_sales_id_sale_fkey FOREIGN KEY (id_sale) REFERENCES public.sales(id_sale) NOT VALID;


--
-- TOC entry 2850 (class 2606 OID 16653)
-- Name: sales sales_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) NOT VALID;


--
-- TOC entry 2851 (class 2606 OID 16658)
-- Name: users users_id_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ground
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_id_role_fkey FOREIGN KEY (id_role) REFERENCES public.roles(id_role) NOT VALID;


--
-- TOC entry 2994 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE historical_chats; Type: ACL; Schema: public; Owner: ground
--

GRANT ALL ON TABLE public.historical_chats TO postgres;


--
-- TOC entry 2996 (class 0 OID 0)
-- Dependencies: 202
-- Name: SEQUENCE historical_chats_id_chat_seq; Type: ACL; Schema: public; Owner: ground
--

GRANT ALL ON SEQUENCE public.historical_chats_id_chat_seq TO postgres;


--
-- TOC entry 2997 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE products; Type: ACL; Schema: public; Owner: ground
--

GRANT ALL ON TABLE public.products TO postgres;


--
-- TOC entry 2999 (class 0 OID 0)
-- Dependencies: 212
-- Name: SEQUENCE products_id_product_seq; Type: ACL; Schema: public; Owner: ground
--

GRANT ALL ON SEQUENCE public.products_id_product_seq TO postgres;


--
-- TOC entry 3000 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE products_sales; Type: ACL; Schema: public; Owner: ground
--

GRANT ALL ON TABLE public.products_sales TO postgres;


--
-- TOC entry 3001 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: ground
--

GRANT ALL ON TABLE public.roles TO postgres;


--
-- TOC entry 3002 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE sales; Type: ACL; Schema: public; Owner: ground
--

GRANT ALL ON TABLE public.sales TO postgres;


--
-- TOC entry 3003 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE users; Type: ACL; Schema: public; Owner: ground
--

GRANT ALL ON TABLE public.users TO postgres;


--
-- TOC entry 3005 (class 0 OID 0)
-- Dependencies: 211
-- Name: SEQUENCE users_id_user_seq; Type: ACL; Schema: public; Owner: ground
--

GRANT ALL ON SEQUENCE public.users_id_user_seq TO postgres;


--
-- TOC entry 3006 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE usuarios; Type: ACL; Schema: public; Owner: ground
--

GRANT ALL ON TABLE public.usuarios TO postgres;


--
-- TOC entry 3008 (class 0 OID 0)
-- Dependencies: 204
-- Name: SEQUENCE usuarios_id_seq; Type: ACL; Schema: public; Owner: ground
--

GRANT ALL ON SEQUENCE public.usuarios_id_seq TO postgres;


-- Completed on 2026-05-26 22:30:24 -05

--
-- PostgreSQL database dump complete
--

