--
-- PostgreSQL database dump
--

\restrict 1wSjBV2e1BKatp1WoaxjsWzIgHWQ05DvqQ4PQdaojoS1k5EIcRCalJRTkSbqTQC

-- Dumped from database version 18.3 (Debian 18.3-1.pgdg12+1)
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: gahtosuperadmin
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO gahtosuperadmin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: gahtosuperadmin
--

CREATE TABLE public.admin_users (
    id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    is_active boolean NOT NULL,
    is_superuser boolean NOT NULL,
    reset_token character varying(255),
    reset_token_expires_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.admin_users OWNER TO gahtosuperadmin;

--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: gahtosuperadmin
--

CREATE SEQUENCE public.admin_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_users_id_seq OWNER TO gahtosuperadmin;

--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gahtosuperadmin
--

ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_users.id;


--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: gahtosuperadmin
--

CREATE TABLE public.campaigns (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    subtitle character varying(255),
    summary text,
    description text NOT NULL,
    image_url character varying(500),
    donation_link character varying(500),
    volunteer_link character varying(500),
    status character varying(50) NOT NULL,
    display_order integer NOT NULL,
    is_featured boolean NOT NULL,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.campaigns OWNER TO gahtosuperadmin;

--
-- Name: campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: gahtosuperadmin
--

CREATE SEQUENCE public.campaigns_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.campaigns_id_seq OWNER TO gahtosuperadmin;

--
-- Name: campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gahtosuperadmin
--

ALTER SEQUENCE public.campaigns_id_seq OWNED BY public.campaigns.id;


--
-- Name: contact_messages; Type: TABLE; Schema: public; Owner: gahtosuperadmin
--

CREATE TABLE public.contact_messages (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    message text NOT NULL,
    status character varying(50) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.contact_messages OWNER TO gahtosuperadmin;

--
-- Name: contact_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: gahtosuperadmin
--

CREATE SEQUENCE public.contact_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contact_messages_id_seq OWNER TO gahtosuperadmin;

--
-- Name: contact_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gahtosuperadmin
--

ALTER SEQUENCE public.contact_messages_id_seq OWNED BY public.contact_messages.id;


--
-- Name: donations; Type: TABLE; Schema: public; Owner: gahtosuperadmin
--

CREATE TABLE public.donations (
    id integer NOT NULL,
    donor_name character varying,
    donor_email character varying,
    amount integer NOT NULL,
    currency character varying,
    provider character varying,
    status character varying,
    provider_reference character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.donations OWNER TO gahtosuperadmin;

--
-- Name: donations_id_seq; Type: SEQUENCE; Schema: public; Owner: gahtosuperadmin
--

CREATE SEQUENCE public.donations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.donations_id_seq OWNER TO gahtosuperadmin;

--
-- Name: donations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gahtosuperadmin
--

ALTER SEQUENCE public.donations_id_seq OWNED BY public.donations.id;


--
-- Name: news_posts; Type: TABLE; Schema: public; Owner: gahtosuperadmin
--

CREATE TABLE public.news_posts (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    headline character varying(255),
    excerpt text,
    content text NOT NULL,
    category character varying(100) NOT NULL,
    featured_image_url character varying(500),
    video_url character varying(500),
    external_link character varying(500),
    is_featured boolean NOT NULL,
    show_in_ticker boolean NOT NULL,
    ticker_order integer NOT NULL,
    status character varying(50) NOT NULL,
    published_at timestamp without time zone,
    created_by_admin_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.news_posts OWNER TO gahtosuperadmin;

--
-- Name: news_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: gahtosuperadmin
--

CREATE SEQUENCE public.news_posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.news_posts_id_seq OWNER TO gahtosuperadmin;

--
-- Name: news_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gahtosuperadmin
--

ALTER SEQUENCE public.news_posts_id_seq OWNED BY public.news_posts.id;


--
-- Name: notification_logs; Type: TABLE; Schema: public; Owner: gahtosuperadmin
--

CREATE TABLE public.notification_logs (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    type character varying(50) NOT NULL,
    is_read boolean NOT NULL,
    related_type character varying(50),
    related_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.notification_logs OWNER TO gahtosuperadmin;

--
-- Name: notification_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: gahtosuperadmin
--

CREATE SEQUENCE public.notification_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notification_logs_id_seq OWNER TO gahtosuperadmin;

--
-- Name: notification_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gahtosuperadmin
--

ALTER SEQUENCE public.notification_logs_id_seq OWNED BY public.notification_logs.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: gahtosuperadmin
--

CREATE TABLE public.reports (
    id integer NOT NULL,
    case_type character varying(120) NOT NULL,
    urgency character varying(50) NOT NULL,
    description text NOT NULL,
    location character varying(255),
    incident_time character varying(255),
    additional_notes text,
    is_anonymous boolean NOT NULL,
    reporter_name character varying(255),
    reporter_email character varying(255),
    reporter_phone character varying(100),
    status character varying(50) NOT NULL,
    ai_severity_score integer,
    ai_summary text,
    escalation_status character varying(50) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    evidence_url text
);


ALTER TABLE public.reports OWNER TO gahtosuperadmin;

--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: gahtosuperadmin
--

CREATE SEQUENCE public.reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reports_id_seq OWNER TO gahtosuperadmin;

--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gahtosuperadmin
--

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;


--
-- Name: site_settings; Type: TABLE; Schema: public; Owner: gahtosuperadmin
--

CREATE TABLE public.site_settings (
    id integer NOT NULL,
    key character varying(100) NOT NULL,
    value text NOT NULL,
    description character varying(255),
    is_public boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.site_settings OWNER TO gahtosuperadmin;

--
-- Name: site_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: gahtosuperadmin
--

CREATE SEQUENCE public.site_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.site_settings_id_seq OWNER TO gahtosuperadmin;

--
-- Name: site_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gahtosuperadmin
--

ALTER SEQUENCE public.site_settings_id_seq OWNED BY public.site_settings.id;


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- Name: campaigns id; Type: DEFAULT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.campaigns ALTER COLUMN id SET DEFAULT nextval('public.campaigns_id_seq'::regclass);


--
-- Name: contact_messages id; Type: DEFAULT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.contact_messages ALTER COLUMN id SET DEFAULT nextval('public.contact_messages_id_seq'::regclass);


--
-- Name: donations id; Type: DEFAULT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.donations ALTER COLUMN id SET DEFAULT nextval('public.donations_id_seq'::regclass);


--
-- Name: news_posts id; Type: DEFAULT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.news_posts ALTER COLUMN id SET DEFAULT nextval('public.news_posts_id_seq'::regclass);


--
-- Name: notification_logs id; Type: DEFAULT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.notification_logs ALTER COLUMN id SET DEFAULT nextval('public.notification_logs_id_seq'::regclass);


--
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);


--
-- Name: site_settings id; Type: DEFAULT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.site_settings ALTER COLUMN id SET DEFAULT nextval('public.site_settings_id_seq'::regclass);


--
-- Data for Name: admin_users; Type: TABLE DATA; Schema: public; Owner: gahtosuperadmin
--

COPY public.admin_users (id, full_name, email, password_hash, role, is_active, is_superuser, reset_token, reset_token_expires_at, created_at, updated_at) FROM stdin;
2	GAHTO Super Admin	admin@gahto.org	$argon2id$v=19$m=65536,t=3,p=4$ea+1Nobwvtca4/x/T8k5hw$IarrDZ0c5PCGON+xkUKdQnzFoKw0+Th11VmaH599AAg	super_admin	t	t	\N	\N	2026-04-12 21:25:12.193832	2026-04-12 21:25:12.193838
\.


--
-- Data for Name: campaigns; Type: TABLE DATA; Schema: public; Owner: gahtosuperadmin
--

COPY public.campaigns (id, title, slug, subtitle, summary, description, image_url, donation_link, volunteer_link, status, display_order, is_featured, start_date, end_date, created_at, updated_at) FROM stdin;
1	Empowerment Beyond Rescue	empowerment-beyond-rescue	Restoring dignity through skills, opportunity, and independence	Supporting survivors of human trafficking with practical skills, mentorship, and pathways to economic independence.	Human trafficking does not end at rescue. For many survivors, the journey to rebuilding their lives is long, complex, and often uncertain. Without access to sustainable opportunities, survivors remain vulnerable to re-exploitation, poverty, and social exclusion.\n\nAt GAHTO, we believe true freedom goes beyond rescue — it is found in empowerment.\n\nThe Empowerment Beyond Rescue campaign is designed to equip survivors of human trafficking with practical, income-generating skills that enable them to regain control of their lives. Through structured vocational training, mentorship programs, and community reintegration support, survivors are given the tools not just to survive, but to thrive.\n\nThis campaign focuses on:\n\n1. Vocational Skill Training: Tailored programs in areas such as tailoring, digital skills, agriculture, and small-scale entrepreneurship.\n2. Mentorship & Guidance: Ongoing support from professionals and community leaders to ensure long-term stability.\n3. Economic Reintegration: Providing starter resources and support systems that enable survivors to build sustainable livelihoods.\n4. Psychosocial Support: Ensuring emotional healing alongside economic empowerment.\n\nEvery trained survivor represents a life reclaimed, a future restored, and a community strengthened.\n\nBy supporting this campaign, you are contributing to a long-term solution — one that breaks cycles of vulnerability and replaces them with opportunity, resilience, and hope.\n\nThis is not charity.\nThis is transformation.	https://drive.google.com/file/d/1U5UAej_nPNu93ZPY5b_JYfrswRxeAjrm/view?usp=sharing	https://www.gahto.org/donate	https://www.gahto.org/contact	active	1	f	2026-02-01 00:00:00	\N	2026-04-14 05:30:39.985319	2026-04-14 05:30:47.205755
\.


--
-- Data for Name: contact_messages; Type: TABLE DATA; Schema: public; Owner: gahtosuperadmin
--

COPY public.contact_messages (id, name, email, message, status, created_at, updated_at) FROM stdin;
1	XHnTXuDiBZMrRuvCshfTpEns	w.e.z.ak.i.g.e.s7.1@gmail.com	JwaNlOZZTNBhKVuLPiFB	new	2026-05-06 17:22:58.43448	2026-05-06 17:22:58.434487
2	tuexTGJgtTENdxXJxvOXcu	j.ut.i.j.oday.u.q.e0.4@gmail.com	srqATICysLlgJZjR	replied	2026-05-29 06:28:15.170221	2026-06-01 18:39:01.312457
3	oqiOPWqPtyPhPnPV	u.p.ed.if.i.j.480@gmail.com	uinnNKBkRUsFrbRbFmF	new	2026-06-03 08:28:27.45421	2026-06-03 08:28:27.454217
4	John Bidemi	drjbolat@gmail.com	I'm messaging to know how fast is rescuing victims of trafficking	new	2026-06-10 10:35:59.435628	2026-06-10 10:35:59.435634
\.


--
-- Data for Name: donations; Type: TABLE DATA; Schema: public; Owner: gahtosuperadmin
--

COPY public.donations (id, donor_name, donor_email, amount, currency, provider, status, provider_reference, created_at, updated_at) FROM stdin;
1	Anonymous	test@email.com	5000	NGN	paystack	pending	\N	2026-05-27 22:00:18.003887+00	\N
2	Anonymous	test@email.com	5000	NGN	paystack	pending	\N	2026-05-27 22:00:20.47101+00	\N
3	Anonymous	test@email.com	5000	NGN	paystack	pending	\N	2026-05-27 22:00:22.704379+00	\N
4	Anonymous	test@email.com	5000	NGN	paystack	pending	\N	2026-05-27 22:00:25.346939+00	\N
5	Anonymous	test@email.com	5000	NGN	paystack	pending	\N	2026-05-27 22:00:25.544795+00	\N
6	Anonymous	test@email.com	5000	NGN	paystack	pending	\N	2026-05-27 22:00:25.752957+00	\N
7	Anonymous	test@email.com	5000	NGN	paystack	pending	\N	2026-05-27 22:00:25.971982+00	\N
8	Anonymous	test@email.com	5000	NGN	paystack	pending	\N	2026-05-27 22:00:26.379504+00	\N
9	Anonymous	test@email.com	5000	NGN	paystack	pending	\N	2026-05-27 22:00:26.712738+00	\N
10	Anonymous	test@email.com	5000	NGN	paystack	pending	\N	2026-05-27 22:00:27.044261+00	\N
11	Anonymous	test@email.com	5000	NGN	paystack	pending	\N	2026-06-26 04:33:19.233173+00	\N
12	Anonymous	test@email.com	5000	NGN	paystack	pending	\N	2026-06-26 04:33:24.966207+00	\N
\.


--
-- Data for Name: news_posts; Type: TABLE DATA; Schema: public; Owner: gahtosuperadmin
--

COPY public.news_posts (id, title, slug, headline, excerpt, content, category, featured_image_url, video_url, external_link, is_featured, show_in_ticker, ticker_order, status, published_at, created_by_admin_id, created_at, updated_at) FROM stdin;
2	GAHTO Founder Calls for Funding As Survivors Share Harrowing Trafficking Ordeal In West Africa	gahto-founder-calls-for-funding-as-survivors-share-harrowing-trafficking-ordeal-in-west-africa	Breaking Trafficking Networks, Saving Lives	GAHTO continues to lead the fight against human trafficking across Nigeria and West Africa, carrying out cross-border rescue missions despite limited funding. Recent survivor accounts reveal the harsh realities of exploitation, as victims are deceived, trafficked, and abused. The organization is calling for stronger partnerships and support to expand rescue efforts, provide care, and help survivors rebuild their lives.	The Founder of the Global Anti Human Trafficking Organization (GAHTO), Prosper K Michael, has renewed his call for increased funding and stronger partnerships to intensify the fight against human trafficking in Nigeria and across West Africa.\n\nFounded in 2019, GAHTO has carried out numerous rescue operations targeting victims of sexual and labour exploitation. Despite operating without direct government funding, the organization continues to coordinate cross-border rescue missions, often in collaboration with diplomatic and security institutions.\n\n“My experience in this field has exposed me to the good, the bad, and the ugly,” the founder stated. “No organization can survive without funds. To rescue, rehabilitate, and empower victims requires substantial financial resources.”\n\nThe renewed appeal comes as two Nigerian survivors. Anita a 19yrs old from River State and Saviour Aloho a 22yrs old from Benue State shared disturbing accounts of how they were deceived, trafficked, and forced into sexual exploitation in Burkina Faso before being rescued.\n\nOne of the survivors said she was lured with promises of legitimate work and financial gain. Instead, she was transported through Benin Republic to Burkina Faso, where her phone and belongings were confiscated. She and others were allegedly locked indoors during the day and forced out at night to engage in prostitution.\n\n“We were told we were going to work and come back with money,” one of them said. “When we arrived, we discovered it was sex work. If we refused, they beat us and threatened us.”\n\nThe victims were reportedly told they must repay an alleged debt of 1.6 million francs CFA which is equivalent to 4million Naira said to cover transportation costs. According to them, refusal to comply resulted in torture, starvation, and confinement.\n\n\nAnother survivor explained that she had been promised work assisting in a shop in Lagos before being transported and eventually trafficked out of Nigeria. Communication with family members was cut off when her phone stopped working.\n\n\n“They locked us in during the day. At night, they would assign us to men. If you were sick and couldn’t work, they didn’t care,” she said, adding that some victims who died were secretly buried without notifying their families.\n\n\nThe victims were eventually rescued through GAHTO’s intervention. The successful repatriation was made possible with the support of the Nigerian Embassy in Burkina Faso. The organization expressed appreciation to Nigeria’s Ambassador to Burkina Faso, Ambassador Muhammad Galadima, and embassy staff for their swift response and collaboration.\n\nGAHTO disclosed that it continues to receive distress calls daily from Nigerian girls trapped in exploitation networks across West Africa.\n\nPoverty Identified as Root Cause\n\nAddressing the root causes of trafficking, the founder Prosper K Michael emphasized that poverty remains the primary driver of the crime.\n\n“Only poverty eradication can easily help in human trafficking prevention,” he said. “Families are struggling to feed their children, and traffickers take advantage of that desperation.”\n\nHe also urged parents to maintain close relationships with their children and monitor unusual job offers, noting that traffickers often exploit secrecy, trust, and emotional manipulation.\n\nCall for Strategic Partnerships\n\nWhile GAHTO currently focuses largely on rescue operations, rehabilitation and reintegration are often handled by government agencies and families due to limited resources. However, the organization’s broader vision is to provide complete rehabilitation, medical care, and empowerment support for survivors.\n\nMany rescued victims reportedly require urgent medical treatment for infections and trauma-related conditions, expenses currently borne by the NGO.\n\n\nThe founder called on individuals, corporate organizations, and international NGOs to partner with GAHTO to strengthen rescue missions, provide medical care, and support survivors with empowerment programs.\n\nIn a strong warning to traffickers, he declared: “Human trafficking is a crime against humanity. No matter how long they operate, they will eventually face justice.”\n\nAs trafficking networks continue to exploit vulnerable Nigerians within and beyond the country’s borders, GAHTO reaffirmed its commitment to restoring dignity and hope to survivors while intensifying efforts to dismantle trafficking syndicates across West Africa.	campaign	https://independent.ng/wp-content/uploads/Screenshot_20260214-175520-585x564.jpg	\N	https://independent.ng/gahto-founder-calls-for-funding-as-survivors-share-harrowing-trafficking-ordeal-in-west-africa/	f	t	0	published	2026-04-13 19:48:57.948283	2	2026-04-13 19:48:57.950637	2026-04-13 19:48:57.950642
3	Group seeks urgent action in tackling human trafficking	group-seeks-urgent-action-in-tackling-human-trafficking	Trapped Abroad: Survivors Speak Out	GAHTO has called for urgent action to combat rising human trafficking in Nigeria, as survivors share how they were deceived and forced into exploitation abroad. The organization is urging stronger partnerships, increased funding, and immediate intervention to rescue victims and support their recovery.	The Global Anti-Human Trafficking Organisation (GAHTO) has called for urgent, coordinated action to address the growing threat of human trafficking in Nigeria.\n\nIn a statement released on Monday, GAHTO’s founder, Prosper Michael, urged the Nigerian government, international bodies, and private stakeholders to strengthen efforts to dismantle trafficking networks and protect vulnerable citizens.\n\nHe described human trafficking as one of the fastest-growing criminal enterprises globally—driven by deception, coercion, and false promises of better opportunities.\n\n“Human trafficking remains a grave crime against humanity,” he said. “These networks prey on vulnerability, stripping victims of their dignity and freedom. Rescue, rehabilitation, and empowerment all require significant resources. Without support, our efforts are limited.”\n\nSurvivors’ Stories: From Hope to Exploitation\n\nThree young women—Abibat, Boluwatife, and Zainab—shared how they were lured with promises of jobs abroad, only to be trafficked into exploitation.\n\nThey were initially told they would be working in Malaysia. Instead, they were moved through illegal routes into Mali and other parts of West Africa.\n\nTheir journey began on February 17, 2026, departing from Lagos through the Seme border into Cotonou, Benin Republic, and across multiple undocumented paths.\n\nThe deception was carefully staged. The victims were recruited by a suspected agent, Peter Osas, and convinced through a video call with a woman identified as “Angel.”\n\n“We were told to cooperate with any questioning, and everything seemed real at the time,” one of the victims recalled.\n\nIt wasn’t until they arrived at a remote settlement in Mali known as Jabani that reality set in.\n\n“They changed our names, placed us under strict watch, and forced us into prostitution,” one of them said.\n\nLife Under Control and Fear\n\nThe victims were subjected to a debt bondage system of approximately 1.2 million CFA francs each. They endured harsh conditions—physical abuse, illness, and restricted communication.\n\n“There was constant pressure to meet daily targets. Some of the girls there were as young as 13,” another survivor revealed.\n\nTheir documents were confiscated, movements restricted, and refusal to comply often led to punishment.\n\nRescue and Ongoing Crisis\n\nTheir eventual rescue came through a joint effort between GAHTO and the National Agency for the Prohibition of Trafficking in Persons (NAPTIP), after they managed to alert their families.\n\nHowever, Michael stressed that their case is just one of many.\n\nHe noted that Nigerian victims are frequently trafficked to countries including Egypt, Libya, Iraq, and across West Africa.\n\n“Victims are reduced to modern-day slavery. Their freedom is taken, and their identities erased,” he said.\n\nHe also pointed out that while many women are forced into sexual exploitation, men are often trafficked for forced labour under false job promises.\n\n“Every victim represents lost potential—people who could have contributed meaningfully to society,” he added.\n\nCall for Immediate Action and Support\n\nGAHTO raised concerns about Nigerians currently stranded in Egypt under exploitative labour conditions, many too weak to work and unable to return due to strict residency policies and lack of funds.\n\nThe organisation is calling for:\n\nImmediate evacuation of stranded victims\nStronger partnerships to disrupt trafficking networks\nIncreased funding for rescue operations\nEstablishment of vocational training centres to support rehabilitation and reintegration\n\nMichael emphasized that tackling human trafficking requires more than rescue missions—it demands long-term investment in prevention, recovery, and empowerment.\n\nAs trafficking networks continue to evolve, GAHTO reaffirmed its commitment to restoring dignity and rebuilding lives—while pushing for collective action to end exploitation.	campaign	https://drive.google.com/file/d/1epXUv9t8envF-rWp59RdQa61Bs_o70k1/view?usp=sharing	\N	https://punchng.com/group-seeks-urgent-action-in-tackling-human-trafficking/	t	t	0	published	2026-04-13 20:01:39.777338	2	2026-04-13 20:01:39.777879	2026-04-13 20:05:08.638804
4	Two Nigerian Teenagers Rescued From Human Trafficking Network In Mali.	two-nigerian-teenagers-rescued-from-human-trafficking-network-in-mali	Two Nigerian Teens Rescued from Trafficking Network in Mali	Two Nigerian teenagers were rescued from a human trafficking network in Mali after being deceived with false job promises. Their experiences reveal a pattern of coercion, abuse, and exploitation affecting vulnerable youths, highlighting the urgent need for awareness and prevention.	Two Nigerian teenagers, 15-year-old Daniela Ighosotinu from Warri, Delta State, and 17-year-old Sonia from Benin City, Edo State, have been rescued from a human trafficking network in Mali after being lured abroad with false promises of legitimate employment.\n\nTheir testimonies reveal a disturbing pattern of deception, coercion, and exploitation, highlighting the growing threat of transnational human trafficking affecting vulnerable young Nigerians.\n\nDaniela recounted that she left Warri in late 2025 after being persuaded by a man she knew in her neighbourhood. Despite warnings from her parents, she secretly travelled in search of better opportunities. The man financed her journey and arranged contacts for her in Mali.\n\nShe explained that she was initially told she would be involved in drug-related work, which she did not fully understand. However, upon arrival, she discovered she would be forced into prostitution.\n\nDaniela described being housed with other girls under strict control, where they were compelled to solicit clients daily. Payments were collected directly by traffickers, leaving victims unaware of how much they earned or owed. Refusal to comply resulted in punishment, starvation, or threats.\n\n“I didn’t know how much I was earning or paying back. I could have worked for years and still been told I hadn’t finished paying,” she said.\n\nShe also recounted instances of physical abuse and intimidation, including threats of being handed over to authorities if she attempted to escape.\n\nHer rescue was made possible after her family intervened and sought help, leading to her return to Nigeria.\n\nSonia’s experience, described as a narrow escape, followed a similar pattern. She left Benin City on March 1, 2026, after being promised a job opportunity in Libya. The journey lasted nearly a week and involved crossing multiple borders, including dangerous forest routes.\n\n“We spent days without sleep. At a point, I was very scared, especially when we had to pass through the forest,” she said.\n\nUpon arrival in Mali, she was told she had to repay 1.5 million CFA francs before gaining independence. However, she soon discovered she was expected to engage in prostitution instead of the promised work.\n\nWhen she refused, her trafficker demanded ₦4 million from her family as compensation. Sonia described harsh living conditions, where more than 30 young girls were kept in makeshift shelters and subjected to similar exploitation.\n\n“She tried to seize my phone so I wouldn’t contact anyone. I had to hide it to stay in touch with my family,” she said.\n\nHer rescue was facilitated through collaboration between authorities and anti-trafficking organisations, leading to her safe return.\n\nThese cases reflect a broader trend of Nigerian youths being trafficked across West African borders under false pretences. Traffickers often exploit poverty, lack of awareness, and family vulnerability.\n\nVictims are frequently trapped in cycles of debt bondage, forced to repay inflated and indefinite costs through exploitation.\n\nBoth Daniela and Sonia have urged young people to be cautious of offers that seem too good to be true.\n\n“I didn’t know about human trafficking before. I thought they wanted to help me,” Sonia said. “It is very risky.”\n\nNow back in Nigeria, Daniela expressed regret over her decision, while Sonia plans to return to her vocational training in fashion design as she rebuilds her life.\n\nAuthorities continue to investigate the trafficking network, with increasing calls for stronger border control, public awareness, and community vigilance.	rescue-update	https://independent.ng/wp-content/uploads/2026/03/Screenshot_20260317-202541.jpg	\N	https://independent.ng/two-nigerian-teenagers-rescued-from-human-trafficking-network-in-mali/	f	t	-2	published	2026-04-13 20:44:52.214112	2	2026-04-13 20:44:52.216065	2026-04-13 20:44:52.216069
5	Physically challenged 22-year-old rescued from Mali trafficking ring	physically-challenged-22-year-old-rescued-from-mali-trafficking-ring	Physically challenged 22-year-old rescued from Mali trafficking ring	GAHTO has raised concerns over rising human trafficking cases following the rescue of a 22-year-old victim trafficked to Mali. Her story highlights how economic hardship and vulnerability continue to expose young women to exploitation, reinforcing the urgent need for awareness, prevention, and survivor support systems.	The Global Anti-Human Trafficking Organisation has raised fresh concerns over a growing surge in human trafficking cases involving young women in Nigeria, following the rescue of a 22-year-old physically challenged victim, Njoku Nnena.\n\nIn a statement issued on Monday, the organisation’s founder, Prosper Michael, highlighted the case as a reflection of a wider and deeply troubling trend across the region.\n\nAccording to Nnena, economic hardship and the responsibility of caring for her three-year-old son and supporting her mother drove her decision to seek opportunities outside her home state. Her journey began in Onitsha before she moved to Lagos, where she was introduced to individuals who later connected her to traffickers.\n\n“I wanted to support my three-year-old son and help my mother. That was why I decided to travel,” she said.\n\nShe explained that she was introduced to a woman around an underbridge in Lagos, after which arrangements were made for her to travel out of the country. She was subsequently transported through Cotonou in the Benin Republic before arriving in Mali, where she was handed over to another member of the trafficking network.\n\nUpon arrival, Nnena was placed in a house with other Nigerian girls under the control of a “madam,” where they were subjected to exploitation and compelled to generate income under unclear and coercive conditions.\n\nHer ordeal was further complicated by her health condition. Nnena, who suffers from epilepsy resulting from a childhood stroke, revealed that she ran out of medication during the journey, leading to a deterioration in her health.\n\n“I didn’t have my drugs with me, and my condition became worse. I couldn’t continue what they asked me to do,” she said.\n\nShe was eventually returned to Nigeria and later rescued with the intervention of GAHTO, arriving safely on Easter Friday.\n\nSpeaking on the situation, her mother, Ipe Ikenna Lora, recounted Nnena’s long-standing health challenges, explaining that she began experiencing convulsions at the age of two, which later developed into epilepsy accompanied by memory loss.\n\nLora noted that the condition contributed to the breakdown of her marriage, leaving her solely responsible for raising her daughter while managing a small business. She added that the burden has significantly affected her own health, leading to high blood pressure.\n\n“I didn’t even know she had travelled to Mali until GAHTO contacted me after rescuing her,” she said.\n\nNow back in Nigeria, Nnena has appealed for support to rebuild her life, expressing a desire to return to school or acquire vocational skills, alongside access to proper medical treatment.\n\n“I want to go back to school or learn a skill so I can take care of myself. I also need medical treatment to manage my condition,” she said.\n\nHer mother also called on government agencies and well-meaning individuals to provide assistance to help her daughter achieve stability and recovery.\n\nIn its response, GAHTO stated that the case reflects a broader and alarming pattern of trafficking across West Africa, particularly targeting vulnerable young women facing economic hardship and health challenges.\n\nThe organisation emphasised the urgent need for increased public awareness, stronger preventive frameworks, and sustainable rehabilitation programmes for survivors.\n\n“This case is not isolated. It highlights a growing trend of trafficking in the region,” the organisation stated.\n\nGAHTO further called on government authorities and key stakeholders to take coordinated action to combat human trafficking and ensure victims receive the necessary support to rebuild their lives with dignity and hope.	rescue-update	https://cdn.punchng.com/wp-content/uploads/2026/04/06130148/WhatsApp-Image-2026-04-06-at-13.00.50.jpeg	\N	https://punchng.com/physically-challenged-22-year-old-rescued-from-mali-trafficking-ring/	t	t	0	published	2026-04-13 20:49:18.1354	2	2026-04-13 20:49:18.135881	2026-04-13 20:49:18.135883
6	Sold a Dream, Trapped in Hell: NAPTIP, GAHTO Expose Brutal Trafficking Network, Demand Urgent Rescue for Nigerians Abroad	sold-a-dream-trapped-in-hell-naptip-gahto-expose-brutal-trafficking-network-demand-urgent-rescue-for-nigerians-abroad	“NAPTIP, GAHTO Expose Growing Human Trafficking Crisis”	NAPTIP and GAHTO have raised alarm over a surge in human trafficking, exposing how Nigerian victims are deceived with fake job offers and forced into exploitation across Africa. Survivor testimonies highlight a growing crisis, prompting urgent calls for rescue efforts, stronger prevention, and rehabilitation support.	The National Agency for the Prohibition of Trafficking in Persons and the Global Anti-Human Trafficking Organization have raised alarm over a disturbing surge in human trafficking involving Nigerian victims, exposing harrowing accounts of deception, abuse, and modern-day slavery across parts of Africa.\n\nSpeaking at a press briefing in Ado-Ekiti, GAHTO Founder, Prosper K. A. Michael, described human trafficking as one of the fastest-growing criminal enterprises globally. He warned that organized syndicates are exploiting the desperation of vulnerable Nigerians through false promises of lucrative jobs abroad.\n\nThe warning follows chilling testimonies from three young victims — Abibat (17), Boluwatife (20), and Zainab (22) — who recounted how they were lured with offers of employment in Malaysia but were instead trafficked through the Seme border into Cotonou, Benin Republic, and onward through irregular routes to Mali.\n\nAccording to the victims, their ordeal began on February 17, 2026, after being recruited by a suspected trafficker identified as Peter Osas. They were instructed to cooperate with officials during transit and were reassured through a staged video call with a woman known as “Angel,” whom they believed to be a legitimate employer.\n\nHowever, upon arrival at a remote settlement identified as Jabani in Mali, the deception became clear.\n\n“They changed our names, seized our freedom, and forced us into prostitution,” one of the victims revealed.\n\nThe victims described being subjected to strict surveillance, physical abuse, illness, and constant pressure to meet daily financial targets under a debt bondage system estimated at about 1.2 million CFA francs each. Communication with the outside world was heavily restricted, and failure to comply often resulted in punishment.\n\nMore disturbing, they reported encountering underage girls — some as young as 13 — trapped in the same exploitative conditions.\n\nTheir eventual rescue was made possible through coordinated efforts between NAPTIP and GAHTO after contact was re-established with their families in Nigeria.\n\nMichael noted that the case represents only a fraction of a much wider crisis, revealing that Nigerian victims are routinely trafficked to countries including Egypt, Libya, Iraq, and several West African nations.\n\nHe explained that victims are often stripped of their identities, with travel documents confiscated and movements tightly controlled, effectively reducing them to forced labour or sexual exploitation.\n\n“Every victim represents lost potential — young Nigerians who could have contributed meaningfully to national development,” he said.\n\nThe anti-trafficking advocate identified poverty, unemployment, and economic hardship as major drivers pushing young Nigerians into the hands of traffickers. Beyond individual suffering, he warned that the trend is eroding national productivity, as victims are cut off from education, skills acquisition, and legitimate economic participation.\n\nRaising further concern, GAHTO disclosed that several Nigerian victims are currently stranded in Egypt under exploitative labour conditions. Many are reportedly too weak to continue working and unable to return home due to strict immigration requirements and lack of funds.\n\nThe organisation has called for urgent evacuation efforts to rescue those affected.\n\nAs part of long-term solutions, GAHTO proposed the establishment of vocational training centres to rehabilitate survivors. These centres would provide skills such as tailoring, baking, hairdressing, welding, and furniture making, alongside temporary shelter and reintegration support.\n\nHowever, Michael emphasized that inadequate funding remains a major constraint.\n\n“Rescue, rehabilitation, and empowerment all require significant resources. Without support, our efforts will remain limited,” he said.\n\nBoth NAPTIP and GAHTO have called on the Nigerian government, international partners, and private stakeholders to strengthen collaboration in dismantling trafficking networks and supporting victims.\n\nThey also urged young Nigerians to remain cautious of overseas job offers that appear too attractive, warning that deception remains the primary tool used by traffickers.\n\nAs more survivor accounts continue to emerge, the agencies stress that urgent and coordinated action is required to address what is increasingly becoming a humanitarian and security crisis.	rescue-update	https://newsmakerslive.org/wp-content/uploads/2026/03/Human-Trafficking-NAPTIP-GAHTO-.jpg	\N	https://newsmakerslive.org/sold-a-dream-trapped-in-hell-naptip-gahto-expose-brutal-trafficking-network-demand-urgent-rescue-for-nigerians-abroad/	t	t	0	published	2026-04-13 20:53:42.646118	2	2026-04-13 20:53:42.646613	2026-04-13 20:55:19.765292
7	GAHTO Raises The Allarm Over Increasing Human Trafficking	gahto-raises-the-allarm-over-increasing-human-trafficking	\N	GAHTO has raised alarm over a surge in human trafficking, as survivor accounts reveal widespread exploitation of Nigerian victims across Africa. The organisation is calling for urgent rescue efforts, stronger prevention strategies, and sustainable rehabilitation support.	The Global Anti-Human Trafficking Organization (GAHTO) has raised serious concerns over the alarming rise in human trafficking, as disturbing survivor accounts continue to reveal the depth of exploitation faced by Nigerian victims trafficked across Africa.\n\nSpeaking at a press briefing in Ado-Ekiti, GAHTO Founder, Prosper K. A. Michael, expressed deep concern over what he described as one of the fastest-growing criminal enterprises globally. He emphasized that human trafficking remains a grave crime against humanity, driven by organized networks that exploit vulnerable individuals through deception, coercion, and false promises.\n\nSurvivors Speak: Deceived and Exploited\n\nIn a chilling account, three young Nigerian women — Abibat (17), Boluwatife (20), and Zainab (22) — recounted how they were lured with promises of legitimate jobs in Malaysia, only to be trafficked to Mali and other African countries for exploitation.\n\nRecruited by a suspected agent identified as Peter Osas, the victims were instructed to comply with questioning and reassured through a staged video call with a woman known as “Angel.” Their journey began on February 17, 2026, moving from Lagos through the Seme border into Cotonou, Benin Republic, and across multiple undocumented routes.\n\nUpon arrival in a remote settlement identified as Jabani in Mali, the victims realized the deception. They were renamed, placed under strict surveillance, and forced into exploitation under a debt bondage system estimated at approximately 1.2 million CFA francs each.\n\nThe victims described harsh conditions, including physical abuse, illness, restricted communication, and constant pressure to meet daily financial targets. Alarmingly, they reported the presence of underage girls — some as young as 13 — facing similar exploitation.\n\nTheir eventual rescue was made possible through coordinated efforts between the National Agency for the Prohibition of Trafficking in Persons (NAPTIP) and GAHTO, following re-established contact with their families.\n\nA Widespread and Growing Crisis\n\nMichael noted that trafficking is not limited to a single region, explaining that Nigerian victims are frequently trafficked to countries such as Egypt, Libya, Iraq, and several West African nations.\n\nHe added that victims are often stripped of their freedom, with travel documents confiscated and movements tightly controlled, effectively reducing them to modern-day slavery.\n\n“Every victim represents lost potential,” he said. “These are individuals who could have contributed to national development if given the opportunity.”\n\nRoot Causes and National Impact\n\nAccording to GAHTO, poverty, unemployment, and economic hardship remain major drivers of human trafficking in Nigeria. Many young people, in search of better opportunities, fall victim to traffickers who exploit their desperation.\n\nMichael stressed that the impact extends beyond individuals, affecting national growth and productivity, as victims are cut off from education, skills development, and economic participation.\n\nUrgent Call for Evacuation and Support\n\nThe organization also raised urgent concerns about Nigerian victims currently trapped in Egypt under exploitative labour conditions. Many are reportedly too weak to continue working and are unable to return home due to strict residency requirements and lack of financial support.\n\nGAHTO has called for immediate evacuation efforts to rescue those affected.\n\nRehabilitation and Future Prevention\n\nTo address the crisis, GAHTO has proposed the establishment of vocational training centres aimed at rehabilitating survivors. These centres would provide practical skills such as tailoring, baking, hairdressing, welding, and furniture making, alongside temporary shelter and reintegration support.\n\nHowever, funding remains a major challenge.\n\n“Rescue, rehabilitation, and empowerment all require significant resources,” Michael stated. “Without adequate support, our efforts remain limited.”\n\nA Call to Action\n\nGAHTO has called on the Nigerian government, international partners, and private stakeholders to intensify collaboration in dismantling trafficking networks and supporting victims.\n\nThe organization also urged young Nigerians to be cautious of overseas job offers that appear too good to be true, warning that deception remains the primary tool used by traffickers.\n\nAs more survivor accounts continue to emerge, GAHTO emphasized that urgent, coordinated action is required to address what is rapidly becoming a major humanitarian and security crisis.	press-coverage	https://yt3.googleusercontent.com/m3FFIizSsOWprAwA9T6dm1aYISbXvoXtETkjQUxWLZZm5fBit1E1agXBusDpJVaBiFtci7RY=w1707-fcrop64=1,00005a57ffffa5a8-k-c0xffffffff-no-nd-rj	\N	https://independent.ng/gahto-raises-the-allarm-over-increasing-human-trafficking/	f	t	0	published	2026-04-13 21:02:00.12591	2	2026-04-13 21:02:00.126235	2026-04-13 21:02:00.126241
8	The Story of Silva	the-story-of-silva	Silva was rescued	\N	Silva was rescued	rescue-update	\N	https://youtube.com/shorts/lcQVbYQsReU?feature=share	https://youtube.com/shorts/lcQVbYQsReU?feature=share	t	t	0	published	2026-04-13 21:33:19.654098	2	2026-04-13 21:33:19.655732	2026-04-13 21:34:32.802461
1	Hope in Action: Ending Human Trafficking with GAHTO	hope-in-action-ending-human-trafficking-with-gahto	Ending Human Trafficking with GAHTO	Discover how GAHTO is making a difference in the fight against human trafficking through awareness, support, and empowerment.	Discover how GAHTO is making a difference in the fight against human trafficking through awareness, support, and empowerment.	awareness	\N	https://share.synthesia.io/bb8a2afe-ed8c-493f-ae50-b982e9700e9b	\N	t	t	0	draft	2026-04-12 21:30:01.567982	2	2026-04-12 21:28:30.407473	2026-04-14 05:20:32.41626
9	Trafficking Survivors: Inside the Côte d’Ivoire Trafficking Ring That Ensnared Four Nigerian Girls	trafficking-survivors-inside-the-cote-divoire-trafficking-ring-that-ensnared-four-nigerian-girls	Four Nigerian Girls Rescued from Côte d’Ivoire Trafficking Network	Four Nigerian girls were rescued from a trafficking network in Côte d’Ivoire after being deceived with false job offers. Their experiences highlight the role of economic hardship in exploitation, as GAHTO calls for stronger awareness, prevention, and support for survivors.	Four Nigerian young women have been rescued from a trafficking network in Côte d’Ivoire and safely repatriated to Nigeria following a coordinated intervention by the Nigerian community in the Bagoué Region.\n\nThe victims, aged between 16 and 23, were trafficked from Delta and Imo States under false promises of legitimate employment.\n\nThe rescue operation was led by Mr. Oluwaseun Odusanya, representative of the Global Anti-Human Trafficking Organization (GAHTO) in Côte d’Ivoire and Chairman of the Nigerian Community in Bagoué Region.\n\nSurvivors’ Ordeal\n\nAccording to the survivors, they endured deception, threats, and exploitation after arriving in Côte d’Ivoire. Two of the victims spent over a year in captivity, one remained for three months, while another was returned within a month.\n\nThe youngest victim, identified as “Small Favour,” aged 16, revealed that she left Nigeria at 15 after being promised a sales job. Due to financial hardship, she had dropped out of school in search of income. Upon arrival, she was forced into exploitation and told she owed her trafficker two million CFA francs before she could regain her freedom.\n\nEsther, 22, from Imo State, was recruited in Lagos and later coerced into exploitation at a hotel, where she was required to remit daily payments to her trafficker.\n\nThe oldest victim, “Senior Favour,” 23, described severe abuse, including beatings and threats when she resisted. After three months, she managed to contact a Nigerian who facilitated her return. She is an orphan and a mother, with her child currently under the care of her mother-in-law.\n\nAnother victim, Favour, 21, also from Delta State, left her restaurant job in Nigeria after being convinced by a former colleague that better opportunities existed abroad. She travelled with her sister but was intercepted by authorities in Côte d’Ivoire and returned after one month.\n\nDrivers of Trafficking\n\nAll four victims identified economic hardship and unemployment as key reasons for seeking opportunities abroad. Their experiences highlight how traffickers continue to exploit vulnerability through deceptive promises.\n\nThe survivors have urged others to remain cautious and verify overseas job offers before making travel decisions.\n\nRescue and Response\n\nThe successful rescue and repatriation were made possible through collaboration between local Nigerian community leaders and anti-trafficking efforts coordinated by GAHTO.\n\nSpeaking on the development, GAHTO Founder, Prosper Kayode Ayobami Michael, emphasized the importance of vigilance in combating trafficking networks operating across West Africa.\n\nHe reiterated that human trafficking remains a crime against humanity and warned perpetrators that their actions will not go unpunished.\n\nSupport and Rehabilitation\n\nThe rescued victims have appealed for support to rebuild their lives, expressing interest in vocational training and legitimate employment opportunities.\n\nMichael noted that GAHTO, established in 2019, continues to focus on rescuing, rehabilitating, and empowering victims despite operating without government funding or major institutional partnerships.\n\nHe stressed that poverty remains a major driver of trafficking and called for stronger economic support systems, improved parent-child communication, and increased community awareness to prevent further cases.\n\nA Call for Collective Action\n\nGAHTO reaffirmed its commitment to expanding rescue operations across Nigeria and West Africa, while calling for stronger collaboration with governments, international partners, and stakeholders.\n\nThe organisation also expressed appreciation to Nigerian embassies across West Africa for their role in facilitating the safe return of rescued victims.\n\nAs trafficking networks continue to operate across borders, stakeholders emphasize that sustained vigilance, awareness, and coordinated intervention remain critical to protecting vulnerable individuals.	rescue-update	https://primetimereports.com.ng/wp-content/uploads/2026/04/IMG-20260416-WA0015-539x600.jpg	\N	https://primetimereports.com.ng/trafficking-survivors-inside-the-cote-divoire-trafficking-ring-that-ensnared-four-nigerian-girls/	t	t	0	published	2026-04-16 11:17:25.988939	2	2026-04-16 11:17:25.991382	2026-04-16 11:17:25.991387
11	Trafficked Nigerians stranded in Egypt need urgent evacuation – GAHTO cries out	trafficked-nigerians-stranded-in-egypt-need-urgent-evacuation-gahto-cries-out	GAHTO Calls for Urgent Evacuation of Trafficked Nigerians in Egypt	GAHTO has raised urgent concern over Nigerians stranded in labour exploitation in Egypt, calling for immediate evacuation. The organisation warns that trafficking continues to rise, driven by poverty and deception, and is urging stronger intervention and support for victims.	The Global Anti-Human Trafficking Organization (GAHTO) has raised urgent concern over the plight of Nigerians trapped in labour exploitation in Egypt, calling for immediate government intervention to evacuate victims who are reportedly too weak to work and unable to return home due to financial and legal constraints.\n\nSpeaking during a media briefing, GAHTO Founder, Comrade Prosper K. A. Michael, described human trafficking as a fast-growing global criminal enterprise with devastating human consequences.\n\nAccording to him, many Nigerian victims in Egypt remain stranded due to the high cost of residency permits, estimated at $1,000, which restricts their movement and prevents their return home.\n\n“Presently, Nigerian victims of labour exploitation in Egypt need evacuation. Many of them are weak, cannot work, and do not have money to return. Their movement is restricted due to residency permit requirements,” he stated.\n\nMichael, who was visibly emotional, lamented the increasing rate of human trafficking, noting that for every victim rescued, many more continue to fall into the hands of traffickers.\n\nHe described trafficking as a crime against humanity driven by organised networks that use deception, coercion, and false promises to lure victims abroad.\n\n“The end result is always exploitation — either forced labour or other forms of abuse. Victims lose their freedom, their documents are seized, and they are reduced to modern-day slavery,” he said.\n\nRoot Causes and Impact\n\nMichael attributed the growing trend largely to poverty and economic hardship, which make young Nigerians vulnerable to promises of better opportunities abroad.\n\n“In Nigeria today, many families struggle to meet basic needs. This makes young people easy targets for traffickers who promise greener pastures,” he added.\n\nHe warned that beyond individual suffering, human trafficking undermines national development, as victims who could contribute to sectors such as healthcare, engineering, agriculture, and business are instead trapped in exploitative conditions.\n\n“Every individual has a role to play in national development if given the opportunity,” he said.\n\nExpanding Trafficking Networks\n\nMichael noted that trafficking affects both men and women. While women are often subjected to sexual exploitation, many young men are trafficked for forced labour under the guise of job opportunities.\n\nHe further disclosed that Nigerian victims are trafficked beyond West Africa to countries including Egypt, Libya, and Iraq, despite ongoing efforts by authorities to curb the trend.\n\nRehabilitation and Long-Term Solutions\n\nTo address the crisis, GAHTO is proposing the establishment of vocational training centres aimed at rehabilitating rescued victims. These centres would provide skills such as tailoring, baking, hairdressing, welding, and furniture making, alongside temporary shelter and reintegration support.\n\n“The mission is only complete when victims are empowered to become self-reliant and reintegrated into society,” he said.\n\nHowever, he identified funding as a major challenge, noting that rescue operations, transportation, feeding, and rehabilitation require substantial resources.\n\nCall for Collective Action\n\nGAHTO has called on the Federal Government, international organisations, and well-meaning individuals to support ongoing efforts, particularly in the areas of victim evacuation, rehabilitation, and prevention.\n\n“Government cannot do it alone. We need collaboration to secure a better future for our youth and to combat this growing menace,” Michael stated.\n\nHe reaffirmed GAHTO’s commitment to fighting human trafficking and expressed optimism that increased support would enable more victims to be rescued and restored to dignity.	breaking	\N	\N	https://www.vanguardngr.com/2026/04/trafficked-nigerians-stranded-in-egypt-need-urgent-evacuation-gahto-cries-out/	t	t	0	published	2026-04-17 17:10:52.32882	2	2026-04-17 17:10:52.330699	2026-04-17 17:10:52.330703
10	We thought it was Malaysia’ – Survivors expose Mali trafficking ring	we-thought-it-was-malaysia-survivors-expose-mali-trafficking-ring	‘We Thought It Was Malaysia’ — Survivors Expose Trafficking Ring”	Three Nigerian girls deceived with promises of jobs in Malaysia were trafficked to Mali and forced into exploitation. Their rescue, led by coordinated intervention from NAPTIP and GAHTO, exposes a growing cross-border trafficking network targeting vulnerable youths.	Three Nigerian young women trafficked under the guise of overseas employment have exposed a cross-border trafficking syndicate that lured them with promises of jobs in Malaysia but forced them into exploitation in Mali.\n\nThe victims — Bella Boluwatife, Linda Zainab, and Amoke Joy — recounted how they were deceived, transported across multiple borders, and held in debt bondage before their eventual rescue through coordinated intervention by authorities and anti-trafficking organisations.\n\nAccording to Bella, their journey began on February 17, 2026, when an agent identified as Peter Osas arranged what appeared to be legitimate travel plans, even involving their parents. To reinforce credibility, a staged video call was organised with a supposed sponsor known as “Angel,” during which they were coached to respond positively.\n\nFrom Ogun State, they were moved through the Seme border into Cotonou, Benin Republic. There, their identities were altered, and travel documents were processed rapidly under suspicious circumstances.\n\nThe journey then took a dangerous turn as they were transported by road for six days through multiple checkpoints on the way to Mali.\n\n“At that point, we realised we were not travellers but cargo,” Bella said, describing how money was exchanged at checkpoints to facilitate their movement.\n\nUpon arrival, the reality became clear.\n\n“There were no houses, only makeshift shelters in a bush. We saw young girls, some as young as 13. That was when it hit us — this was not Malaysia,” she said.\n\nThe victims said they were immediately forced into exploitation and informed that each owed 1.5 million CFA francs, a debt they had to repay to regain their freedom.\n\nZainab confirmed that their phones were confiscated, and they were separated and assigned to different handlers.\n\n“We begged to be allowed to do other jobs, but we were told there was no alternative. Customers came daily, and all the money went to our handlers. We had no control over anything,” she said.\n\nAttempts to resist proved futile, as the system was designed to exert psychological and financial control over them.\n\nThe breakthrough came when Joy managed to alert her family in Nigeria, triggering a rescue effort.\n\nHer family contacted the National Agency for the Prohibition of Trafficking in Persons (NAPTIP), which escalated the matter to the Global Anti-Human Trafficking Organization (GAHTO), leading to the involvement of the Nigerian embassy in Mali.\n\nUnder mounting pressure, the traffickers released the victims and arranged their return to Nigeria.\n\n“Our handlers became nervous when they realised authorities were involved. They asked us to lie to our families, but we refused. Eventually, they put us on a bus back home with little money,” Joy said.\n\nCommenting on the development, GAHTO Founder, Prosper K. A. Michael, described human trafficking as a highly organised transnational crime driven by deception and exploitation.\n\n“Victims are lured with promises of better opportunities abroad but end up in forced labour or exploitation. Their documents are seized, movements restricted, and they are subjected to modern-day slavery,” he said.\n\nHe added that similar rescue operations have taken place in countries including Egypt, Libya, and Iraq, warning that trafficking networks continue to target vulnerable Nigerians.\n\nNow back in Nigeria, the victims say they are focused on rebuilding their lives and have warned others against falling for similar schemes.\n\n“We thought we were travelling for work. We didn’t know we were walking into a trap,” Bella said.	rescue-update	https://cdn.vanguardngr.com/wp-content/uploads/2018/11/HUMAN-TRAFFICKING2-e1594507080705.gif	\N	https://www.vanguardngr.com/2026/04/we-thought-it-was-malaysia-survivors-expose-mali-trafficking-ring/	f	t	0	published	2026-04-17 16:00:33.808058	2	2026-04-17 16:00:33.809813	2026-04-17 17:12:06.512054
12	They deceived us; but I made money’ — Women trafficked to Ivory Coast for prostitution	they-deceived-us-but-i-made-money-women-trafficked-to-ivory-coast-for-prostitution	Rescued Girls Expose Trafficking Horror in Côte d’Ivoire	Four Nigerian girls rescued from a trafficking network in Côte d’Ivoire have shared painful stories of deception, abuse, and survival after being lured abroad with promises of legitimate jobs. Their testimonies highlight the growing dangers of cross-border human trafficking affecting vulnerable young Nigerians.	Rescued Nigerian Girls Reveal Harsh Reality of Trafficking in Côte d’Ivoire\n\nFour Nigerian girls rescued from a human trafficking network in Côte d’Ivoire have shared painful stories of deception, exploitation, and survival after being lured abroad with promises of legitimate work.\n\nThe victims, aged between 16 and 23, described how economic hardship and false promises pushed them into dangerous situations far from home.\n\nTheir testimonies expose a growing pattern of cross-border trafficking targeting vulnerable young Nigerians, especially girls seeking better opportunities.\n\nFalse Promises and Forced Exploitation\n\nOne of the victims, Esther, 23, said she was recruited in Lagos with assurances that she would be selling clothes in Côte d’Ivoire.\n\n“When I got there, there was nothing like that. They forced me into prostitution,” she said.\n\nShe explained that she spent nearly a year under strict control, handing over daily earnings ranging from 10,000 to 26,000 CFA francs to her trafficker.\n\nDespite the exploitation, she admitted the financial returns initially influenced her perception.\n\n“The money was more than what I could make in Nigeria,” she said.\n\nA 16-Year-Old’s Regret\n\nFor Favour, a 16-year-old from Delta State, the experience became a painful lesson.\n\n“I regret it. It was tough. I was alone,” she said.\n\nShe revealed that she left Nigeria at just 15 years old without informing her parents, hoping to support her family financially.\n\nInstead, she was handed over to a trafficker commonly referred to as a “madam” and forced to work under harsh conditions to repay a debt of 2 million CFA francs.\n\nEven after repaying the debt, she said her trafficker still refused to release her.\n\n“It was only after I contacted someone who helped me reach the Nigerian Embassy that I was able to return home,” she explained.\n\nFavour, who is now pregnant, said she is focused on rebuilding her life.\n\nViolence, Isolation, and Survival\n\nAnother victim, also identified as Favour, 23, said she was physically assaulted after refusing to cooperate.\n\n“They told me I would sell clothes. When I arrived, there was no shop. They said I must do the work,” she recalled.\n\nWhen she resisted, her traffickers seized her phone and beat her repeatedly.\n\nShe eventually escaped with the help of a good Samaritan who assisted her return to Nigeria.\n\n“I just want to learn hairdressing and take care of my child,” she said.\n\nFaith, 21, shared a similar experience. She said she travelled after being persuaded by a colleague who promised better income opportunities abroad.\n\n“I was told not to tell anyone,” she said.\n\nHowever, shortly after arriving in Côte d’Ivoire, a police raid disrupted the trafficking operation, leaving her stranded while her sister was arrested.\n\n“I didn’t do the work. I just wanted to come back,” she said.\n\nNow reunited with their families, the survivors say they are determined to rebuild their lives through vocational skills and honest work.\n\nGrowing Concerns Over Human Trafficking\n\nConfirming the rescue, GAHTO representative in Côte d’Ivoire and Chairman of the Nigerian Community in Bagoue Region, Oluwaseun Odusanya, said stronger awareness campaigns, tighter border monitoring, and better support systems are urgently needed.\n\nThe victims warned other young Nigerians to be cautious of overseas offers that seem too good to be true.\n\n“I will tell anyone thinking of going not to try it. It is not worth it,” the youngest victim warned.\n\nTheir stories reflect the broader dangers of irregular migration and the growing activities of trafficking networks across West Africa.	rescue-update	https://cdn.vanguardngr.com/wp-content/uploads/2026/05/IMG-20260506-WA0032-1.jpg	\N	https://www.vanguardngr.com/2026/05/they-deceived-us-but-i-made-money-women-trafficked-to-ivory-coast-for-prostitution/	t	t	0	published	2026-05-10 11:54:27.193672	2	2026-05-10 11:54:27.195209	2026-05-10 11:54:27.195212
13	GAHTO Rescues Plateau Women from Alleged Trafficking Network in Mali	gahto-rescues-plateau-women-from-alleged-trafficking-network-in-mali	GAHTO Rescues Plateau Women from Mali Trafficking Ring	Three women from Plateau State have been rescued from an alleged trafficking network in Mali after being deceived with promises of employment. Their stories highlight the growing threat of human trafficking and the urgent need for stronger protection, awareness, and support for vulnerable Nigerians.	Three women from Plateau State have returned to Nigeria after being rescued from an alleged human trafficking network in Mali, where they say they were deceived with promises of jobs and forced into prostitution.\n\nThe victims—Becky Ibrahim, Blessing Nanging, and Miracle Yakubu—were rescued through the intervention of the Global Anti-Human Trafficking Organisation (GAHTO), reigniting concerns over the growing threat of human trafficking and labour exploitation targeting vulnerable Nigerians.\n\nPromises of Employment Turned into Exploitation\n\nSpeaking after their rescue, the women recounted how poverty and unemployment made them vulnerable to traffickers posing as job recruiters.\n\nBecky Ibrahim, a 35-year-old widow and mother of three, said she accepted an offer from a man who promised to help her secure employment in Lagos. Hoping to provide for her children and pay their school fees, she agreed to travel.\n\nInstead of Lagos, the journey continued through neighbouring countries and eventually ended in Mali.\n\n“We were beaten whenever we refused,” she alleged.\n\nAccording to Becky, what was presented as a path to a better life quickly became a nightmare of exploitation and abuse.\n\n‘The Job Was Never Real’\n\nAnother victim, Blessing Nanging, said she believed she had secured legitimate work that would allow her to support her two children.\n\nHowever, she later discovered that the promised shop job did not exist.\n\n“They intimidated and punished anyone who refused,” she said.\n\nBlessing explained that many victims were controlled through fear, threats, and physical punishment, making escape extremely difficult.\n\nEscape Attempt Ends in Violence\n\nFor 23-year-old Miracle Yakubu, the ordeal became even more traumatic after she attempted to escape.\n\nAccording to her account, she was attacked and stabbed with a broken bottle after making plans to flee with another victim.\n\nDespite the violence, she survived and was eventually rescued alongside the others.\n\nThe women have since urged young Nigerians to be extremely cautious of suspicious job offers and travel opportunities presented by strangers.\n\n“Stay where you are and find something genuine to do. Don’t follow people because they promise you jobs abroad,” Becky warned.\n\nCommunity Support and Calls for Action\n\nFollowing their return, the women were received by members of the BIROM Association in Lagos, who helped coordinate their journey back to Plateau State.\n\nNaomi Badu, Financial Secretary of the association, said the group often assists members facing hardship, trafficking, or other forms of distress.\n\nHuman rights advocate and journalist Jumai Madaki described the increasing rate of trafficking among young Nigerian women as alarming.\n\nShe noted that poverty, insecurity, family instability, and gender-based discrimination continue to create opportunities for traffickers who exploit vulnerable individuals with false promises of employment abroad.\n\nMadaki also warned that some former victims later become recruiters for trafficking networks after returning home with money, helping to sustain the cycle of exploitation.\n\nLabour Exploitation Concerns in Egypt\n\nGAHTO President, Prosper Michael, also raised concerns about reports of labour exploitation involving Nigerians trafficked to Egypt.\n\nAccording to him, some victims have had their passports confiscated upon arrival and were allegedly forced to work for extended periods without pay.\n\n“We will submit the names of those involved to security agencies for investigation and possible arrest,” he said.\n\nGAHTO disclosed that it has received multiple complaints regarding agents and sponsors accused of exploiting Nigerians in Egypt and other countries.\n\nThe organisation called on the Nigerian government, security agencies, and international partners to intensify efforts against trafficking syndicates operating across Africa and the Middle East.\n\nA Growing Threat\n\nThe rescue of the three Plateau women highlights the continued danger posed by trafficking networks that prey on poverty, desperation, and the hope for better opportunities.\n\nAs more victims come forward, anti-trafficking advocates are calling for stronger laws, increased public awareness, enhanced border monitoring, and greater support for survivors seeking to rebuild their lives.	rescue-update	https://d1jcea4y7xhp7l.cloudfront.net/wp-content/uploads/2026/05/ail-16-225x400.jpg	\N	https://thesun.ng/gahto-rescues-plateau-women-after-alleged-cross-border-sex-trafficking-to-mali/	t	t	0	published	2026-05-24 09:31:15.716469	2	2026-05-24 09:31:15.718346	2026-05-24 09:31:15.71835
14	How Fake Lagos Job Offers Trapped Plateau Women in Cross-Border Sex Trafficking	how-fake-lagos-job-offers-trapped-plateau-women-in-cross-border-sex-trafficking	Fake Job Offers Lead Plateau Women into Mali Trafficking Trap	Three women from Plateau State have recounted how fake job offers led them into a trafficking network in Mali, where they faced exploitation and abuse. Rescued by GAHTO, their stories highlight the growing threat of human trafficking and the urgent need for stronger prevention efforts.	Fake Lagos Job Offers Lead Plateau Women into Trafficking Trap in Mali\n\nThree women from Plateau State have shared how promises of legitimate jobs in Lagos turned into a nightmare of exploitation after they were allegedly trafficked across borders and forced into prostitution in Mali.\n\nThe victims—Becky Ibrahim, Blessing Nanging, and Miracle Yakubu—were recently rescued and returned to Nigeria through the intervention of the Global Anti-Human Trafficking Organisation (GAHTO).\n\nTheir stories shed light on the growing threat of human trafficking networks that prey on poverty, unemployment, and desperation among vulnerable Nigerians.\n\nA Search for Opportunity Ends in Exploitation\n\nFor Becky Ibrahim, a 35-year-old widow and mother of three, the promise of employment seemed like an answer to her struggles.\n\nAfter losing her husband, Becky was approached by a man who offered to help her secure work in Lagos. Hoping to provide for her children and keep them in school, she accepted.\n\nHowever, what was supposed to be a journey to Lagos extended through Cotonou and eventually into Mali.\n\nAccording to Becky, it was only after arriving that she realised she had been trafficked.\n\n“We were beaten whenever we refused,” she recalled.\n\nInstead of the job she was promised, Becky said she and other women were forced into prostitution and subjected to abuse whenever they resisted.\n\n‘The Job Never Existed’\n\nAnother victim, Blessing Nanging, said she left Plateau State believing she had secured employment that would help her care for her two children.\n\nShe explained that the traffickers initially spoke of opportunities in Lagos before later informing them they were travelling abroad.\n\nUpon arriving in Mali, she discovered that the promised shop work did not exist.\n\n“They intimidated and punished anyone who refused,” she said.\n\nAccording to Blessing, fear and violence were used to keep victims under control and prevent them from escaping.\n\nViolence After Attempting to Escape\n\nFor 23-year-old Miracle Yakubu, the ordeal became even more traumatic after she attempted to flee.\n\nShe alleged that traffickers attacked her, stabbed her with a bottle, and beat her after discovering plans to escape.\n\nDespite the violence, she survived and was eventually rescued alongside the other victims.\n\nThe women have since urged young Nigerians to be cautious of suspicious job offers and migration opportunities that appear too good to be true.\n\n“Stay where you are and find something genuine to do. Don’t follow people because they promise you work abroad,” Becky warned.\n\nCommunity Support and Reintegration\n\nFollowing their rescue, the women were received in Lagos by GAHTO and members of the BIROM Association, who assisted with arrangements for their safe return to Plateau State.\n\nNaomi Badu, Financial Secretary of the association, said the group quickly mobilised after learning that the victims had returned to Nigeria.\n\n“We always respond whenever our people are in distress—whether stranded, trafficked, or facing hardship. Our goal is to ensure they get home safely,” she said.\n\nExperts Warn of Rising Trafficking Threat\n\nHuman rights advocate and journalist Jumai Madaki described the increasing rate of trafficking involving young Nigerian women as alarming.\n\nAccording to her, poverty, insecurity, family breakdown, and limited opportunities continue to make many young women easy targets for traffickers.\n\nShe warned that victims are often deceived with promises of employment abroad, only to face exploitation, violence, and abuse.\n\nMadaki also expressed concern that some former victims later become recruiters for trafficking networks, helping to lure others into similar situations.\n\nShe called for stronger community action, tougher anti-trafficking laws, and increased support for the National Agency for the Prohibition of Trafficking in Persons (NAPTIP).\n\nGAHTO Raises Alarm Over Labour Exploitation in Egypt\n\nGAHTO President, Prosper Michael, also raised concerns about reports of labour exploitation involving Nigerians trafficked to Egypt.\n\nAccording to him, some traffickers allegedly confiscate victims’ passports upon arrival and subject them to harsh working conditions for up to two years without proper compensation.\n\n“We will forward the names of those involved to the appropriate security agencies for investigation and possible arrest,” he said.\n\nThe organisation called on the Nigerian government, security agencies, and international partners to intensify efforts against trafficking and labour exploitation networks operating across Africa and the Middle East.\n\nA Growing Need for Action\n\nThe rescue of the Plateau women serves as another reminder of the dangers posed by trafficking syndicates that exploit vulnerable individuals with false promises of jobs and better opportunities.\n\nAdvocates say stronger awareness campaigns, improved economic opportunities, stricter border monitoring, and better support for survivors are essential to preventing more Nigerians from falling victim to trafficking networks.	breaking	https://primetimereports.com.ng/wp-content/uploads/2026/05/IMG-20260521-WA0047.jpg	\N	https://primetimereports.com.ng/how-fake-lagos-job-offers-trapped-plateau-women-in-cross-border-sex-trafficking/	t	f	0	published	2026-05-24 10:13:18.053753	2	2026-05-24 10:13:18.055923	2026-05-24 10:13:18.055927
15	Plateau Women Rescued from Trafficking Network in Mali as GAHTO Raises Alarm Over Exploitation in Egypt	plateau-women-rescued-from-trafficking-network-in-mali-as-gahto-raises-alarm-over-exploitation-in-egypt	Promised Jobs, Trapped in Mali	Three women from Plateau State have been rescued from a trafficking network in Mali after being lured with promises of employment. Their experiences highlight the growing threat of human trafficking and labour exploitation, as GAHTO calls for stronger action to protect vulnerable Nigerians.	Three women from Plateau State have been rescued from an alleged human trafficking network in Mali after being deceived with promises of legitimate jobs, only to find themselves trapped in exploitation and abuse.\n\nThe victims—Becky Ibrahim, Blessing Nanging, and Miracle Yakubu—were returned to Nigeria through the intervention of the Global Anti-Human Trafficking Organisation (GAHTO), shedding fresh light on the growing dangers of cross-border trafficking affecting vulnerable Nigerians.\n\nFrom Job Promises to a Life of Exploitation\n\nThe women said they initially accepted offers of employment in Lagos, hoping to escape poverty and provide better lives for their families.\n\nFor Becky Ibrahim, a 35-year-old widow and mother of three, the opportunity appeared to be a lifeline.\n\nAfter being approached by a man who promised to help her secure work in Lagos, she agreed to travel, hoping to support her children and pay their school fees.\n\nInstead, the journey continued beyond Nigeria's borders, through Cotonou and eventually into Mali.\n\nAccording to Becky, it was there she realised the promise of employment was a lie.\n\n“We were beaten whenever we refused,” she recalled.\n\nShe said the victims were forced into prostitution and subjected to intimidation and abuse whenever they resisted.\n\n‘The Shop Job Was Never Real’\n\nAnother victim, Blessing Nanging, said she accepted the offer because she could no longer adequately provide for her two children.\n\nShe explained that what was presented as a legitimate job eventually turned out to be exploitation.\n\n“The shop work they promised never existed,” she said. “Anyone who refused was intimidated and punished.”\n\nBlessing described living under constant fear, where compliance was demanded and resistance carried consequences.\n\nEscape Attempt Turns Violent\n\nFor 23-year-old Miracle Yakubu, the ordeal became even more traumatic after she attempted to escape.\n\nAccording to her account, traffickers discovered her plans and responded with violence.\n\nShe alleged that she was attacked, beaten, and stabbed with a broken bottle after trying to flee alongside another victim.\n\nDespite the abuse, Miracle survived and was eventually rescued through coordinated intervention efforts.\n\nThe women are now urging young Nigerians to be cautious of suspicious job offers and migration opportunities.\n\n“Stay where you are and find something genuine to do. Don’t follow people because they promise you jobs abroad,” Becky warned.\n\nSupport from Community and Advocates\n\nFollowing their return, members of the BIROM Association community in Lagos assisted with arrangements to reunite the victims with their families in Plateau State.\n\nNaomi Badu, Financial Secretary of the association, said the group remains committed to supporting community members facing distress, trafficking, or hardship.\n\nHuman rights advocate and journalist Jumai Madaki described the rise in trafficking cases involving young Nigerian women as deeply concerning.\n\nAccording to her, poverty, insecurity, family instability, and discrimination against girls continue to make many young women vulnerable to traffickers who disguise exploitation as opportunity.\n\nShe warned that some victims are subjected to severe abuse and violence, while others are manipulated into recruiting additional victims after returning home.\n\nMadaki called for stronger community engagement, tougher anti-trafficking laws, and increased support for the National Agency for the Prohibition of Trafficking in Persons (NAPTIP).\n\nGAHTO Raises Alarm Over Labour Exploitation in Egypt\n\nBeyond trafficking for sexual exploitation, GAHTO has also expressed concern over reports of labour exploitation involving Nigerians trafficked to Egypt.\n\nAccording to GAHTO President Prosper Michael, some victims allegedly have their passports confiscated upon arrival and are forced to work under harsh conditions for up to two years without pay.\n\n“We will submit the names of those involved to security agencies for investigation and possible arrest,” he said.\n\nThe organisation revealed that multiple complaints have been received regarding agents and sponsors accused of exploiting Nigerians abroad.\n\nGAHTO is calling on the Nigerian government, security agencies, and international partners to intensify efforts against trafficking and labour exploitation networks operating across Africa and the Middle East.\n\nA Growing Threat That Demands Action\n\nThe rescue of the three women highlights the continued danger posed by trafficking syndicates that exploit poverty, unemployment, and desperation with false promises of jobs and a better future.\n\nAdvocates say stronger awareness campaigns, improved economic opportunities, stricter border controls, and enhanced support for survivors are critical to breaking the cycle of trafficking and protecting vulnerable Nigerians.	rescue-update	https://www.nairaland.com/attachments/19956922_56f04514b5f24367b90721e59d1c585c_jpeg44ef7499c2bd6055989475b05c5327a1	\N	https://www.nairaland.com/8677096/plateau-women-rescued-after-alleged#139495267	f	f	0	published	2026-05-24 10:30:53.899801	2	2026-05-24 10:30:53.9019	2026-05-24 10:30:53.901904
16	GAHTO Rescues Plateau Women from Alleged Trafficking Network in Mali	gahto-rescues-plateau-women-from-alleged-trafficking-network-in-mali-2	Survivors Expose Cross-Border Trafficking Network	Three women from Plateau State have been rescued from an alleged trafficking network in Mali after being deceived with promises of employment. Their stories highlight the dangers of human trafficking and the urgent need for stronger action to protect vulnerable Nigerians from exploitation.	Three women from Plateau State have returned home after being rescued from an alleged human trafficking network in Mali, where they say they were deceived with promises of employment and forced into prostitution.\nThe victims—Becky Ibrahim, Blessing Nanging, and Miracle Yakubu—were rescued through the intervention of the Global Anti-Human Trafficking Organisation (GAHTO), drawing renewed attention to the growing threat of human trafficking and labour exploitation affecting vulnerable Nigerians.\nA Promise of Work That Became a Nightmare\nLike many victims of trafficking, the women said they were motivated by the desire to escape poverty and provide for their families.\nFor Becky Ibrahim, a 35-year-old widow and mother of three, the promise of a job in Lagos seemed like an opportunity to secure a better future for her children.\nShe recalled being approached in Jos by a man who offered to connect her with employment opportunities. Trusting his assurances, she agreed to travel.\nWhat she thought would be a journey to Lagos eventually extended through Cotonou and into Mali.\nAccording to Becky, it was only after arriving that she realised she had been trafficked.\n“We were beaten whenever we refused,” she said.\nInstead of the promised job, Becky alleged that she and other women were forced into prostitution and punished whenever they resisted.\n‘The Job Never Existed’\nAnother survivor, Blessing Nanging, said she accepted the offer because she could no longer adequately provide for her two children.\nShe explained that the traffickers initially promised legitimate employment, but the truth emerged only after they arrived in Mali.\n“The shop work they talked about was never real,” she said. “Anyone who refused was intimidated and punished.”\nBlessing described an environment where fear and abuse were used to maintain control over victims.\nViolence After Attempting to Escape\nFor Miracle Yakubu, 23, the ordeal became even more severe after she attempted to escape.\nAccording to her account, traffickers discovered her plans and attacked her.\nShe alleged that she was beaten and stabbed with a broken bottle after attempting to flee alongside another victim.\nDespite the violence she endured, Miracle survived and was eventually rescued.\nThe women are now urging Nigerians, especially young people, to be cautious of suspicious job offers and migration opportunities.\n“Stay where you are and find something genuine to do. Don’t follow people because they promise you jobs abroad,” Becky advised.\nCommunity Support Helps Survivors Return Home\nFollowing their rescue, members of the BIROM Association community in Lagos helped coordinate the women's safe return to Plateau State.\nNaomi Badu, Financial Secretary of the association, said the group immediately mobilised after learning the victims had returned to Nigeria.\n“We always try to support our people whenever they are stranded, trafficked, or in distress,” she said.\nThe association assisted with logistics and family reunification efforts to ensure the women could safely begin rebuilding their lives.\nExperts Warn of a Growing Crisis\nHuman rights advocate and journalist Jumai Madaki expressed concern over the increasing rate of trafficking involving young Nigerian women.\nAccording to her, poverty, insecurity, family instability, and discrimination against girls continue to create opportunities for traffickers who prey on vulnerable individuals with false promises of employment.\nShe warned that victims often face severe abuse, violence, and exploitation, while some former victims later become recruiters, helping trafficking networks expand their operations.\nMadaki called for stronger anti-trafficking laws, increased public awareness, and greater support for the National Agency for the Prohibition of Trafficking in Persons (NAPTIP).\nGAHTO Raises Alarm Over Labour Exploitation in Egypt\nBeyond trafficking for sexual exploitation, GAHTO has also raised concerns about reports of labour exploitation involving Nigerians trafficked to Egypt.\nAccording to GAHTO President Prosper Michael, some victims allegedly have their passports confiscated upon arrival and are forced to work under harsh conditions for extended periods without pay.\n“We will submit the names of those involved to security agencies for investigation and possible arrest,” he said.\nThe organisation disclosed that it has received multiple complaints regarding agents accused of exploiting Nigerians abroad and called for stronger action against trafficking syndicates operating across Africa and the Middle East.\nA Call for Collective Action\nThe rescue of the three Plateau women serves as another reminder of the dangers posed by trafficking networks that exploit desperation and economic hardship.\nAdvocates say tackling the crisis will require stronger law enforcement, community vigilance, economic empowerment, and increased support for survivors seeking to rebuild their lives.\nTogether, they say, these efforts can help prevent more Nigerians from falling victim to traffickers who profit from false promises and human suffering.	rescue-update	https://independent.ng/wp-content/uploads/2026/05/IMG-20260524-WA0060.jpg	\N	https://independent.ng/gahto-rescues-plateau-women-after-alleged-cross-border-sex-trafficking-to-mali/	t	f	0	published	2026-05-25 12:40:48.05021	2	2026-05-25 12:40:48.052276	2026-05-25 12:40:48.052281
17	How we were trafficked with fake Lagos jobs to Mali, by rescued women victim	how-we-were-trafficked-with-fake-lagos-jobs-to-mali-by-rescued-women-victim	Rescued Women Reveal Mali Trafficking Ordeal	Three women from Plateau State have shared how fake job offers led them into a trafficking network in Mali, where they faced exploitation and abuse. Rescued by GAHTO, their stories highlight the growing dangers of human trafficking and the need for stronger protection for vulnerable Nigerians.	Rescued Plateau Women Reveal How Fake Job Offers Led Them into Trafficking Network in Mali\nThree women from Plateau State have recounted how promises of legitimate jobs in Lagos turned into a harrowing ordeal after they were allegedly trafficked to Mali and forced into prostitution.\nThe victims—Becky Ibrahim, Blessing Nanging, and Miracle Yakubu—shared their experiences after being rescued and repatriated to Nigeria by the Global Anti-Human Trafficking Organisation (GAHTO).\nTheir stories highlight how poverty, unemployment, and desperation continue to make many Nigerians vulnerable to trafficking syndicates that operate under the guise of employment opportunities.\nA Search for Work Becomes a Nightmare\nBecky Ibrahim, a 35-year-old widow and mother of three, said she agreed to travel after being approached by a man who promised to help her secure employment in Lagos.\nStruggling financially following the death of her husband, Becky hoped the opportunity would enable her to care for her children and keep them in school.\nInstead, the journey continued beyond Nigeria, through Cotonou and eventually into Mali.\nAccording to Becky, it was only after arriving that she discovered the promised jobs did not exist.\nShe alleged that the women were informed they would be engaged in prostitution and that resistance was met with intimidation and physical abuse.\n“We were beaten whenever we refused,” she said.\nPromises of Employment Turned into Exploitation\nAnother survivor, Blessing Nanging, said she accepted the offer because she was unable to adequately provide food and other necessities for her two children.\nShe explained that she initially believed she would be working in a shop or business establishment in Lagos.\nHowever, her suspicions grew when the journey extended into neighbouring countries.\nBlessing said the traffickers eventually admitted that the women had been recruited for prostitution rather than the jobs they had originally discussed.\nAccording to her, victims who resisted were frequently threatened and punished.\nViolence After Attempting to Escape\nMiracle Yakubu, 23, recounted how she allegedly suffered physical assault after attempting to escape.\nShe claimed that she and another victim had planned to flee when traffickers discovered their intentions.\nAccording to Miracle, she was attacked and beaten as punishment for attempting to leave.\nDespite the ordeal, she was eventually rescued and safely returned to Nigeria.\nThe women have since urged young Nigerians to carefully verify job opportunities and be wary of offers that require unexplained travel across borders.\nCommunity Support Helps Survivors Return Home\nUpon their return, the victims were received by representatives of the BIROM Association in Lagos, who helped coordinate support and transportation back to Plateau State.\nNaomi Badu, Financial Secretary of the association, said the organisation immediately stepped in after learning the women had returned to Nigeria through Ghana.\n“We always respond whenever our people are in distress, whether sick, stranded, or trafficked. We make sure they are safely transported home and reunited with their families,” she said.\nExperts Warn of Rising Human Trafficking\nHuman rights advocate and journalist Jumai Madaki described the increasing rate of trafficking involving young Nigerian women as alarming.\nShe noted that poverty, insecurity, family instability, and discrimination against girls continue to make many young women vulnerable to traffickers who disguise exploitation as opportunity.\nAccording to Madaki, some victims are subjected to severe abuse and violence, while others eventually become recruiters for trafficking networks after returning home.\nShe called for stronger community engagement, tougher anti-trafficking laws, and increased funding for the National Agency for the Prohibition of Trafficking in Persons (NAPTIP).\nGAHTO Raises Alarm Over Labour Exploitation in Egypt\nGAHTO President Prosper Michael also expressed concern over reports of labour exploitation involving Nigerians trafficked to Egypt.\nAccording to him, some sponsors and traffickers allegedly confiscate victims’ international passports and force them into exploitative labour arrangements lasting between 18 and 24 months.\nHe said GAHTO would submit the identities of suspected perpetrators to security agencies for investigation and possible inclusion on watchlists.\nMichael further disclosed that multiple complaints had been received regarding agents accused of exploiting Nigerians abroad.\nHe called on the Nigerian government, security agencies, and international organisations to intensify efforts against trafficking and labour exploitation networks operating across Africa and the Middle East.\nA Call for Vigilance\nThe case has once again drawn attention to the growing activities of trafficking syndicates that target vulnerable Nigerians with false promises of employment and better opportunities.\nAdvocates say awareness, economic empowerment, stronger law enforcement, and community vigilance remain critical in preventing more Nigerians from falling victim to human trafficking.	rescue-update	\N	\N	https://thenationonlineng.net/how-we-were-trafficked-with-fake-lagos-jobs-to-mali-by-rescued-women-victim/	t	f	0	published	2026-06-01 18:53:30.614605	2	2026-06-01 18:53:30.616145	2026-06-01 18:53:30.616148
18	Seven Nigerian Girls Rescued from Trafficking Networks in Mali, Burkina Faso, and Côte d’Ivoire	seven-nigerian-girls-rescued-from-trafficking-networks-in-mali-burkina-faso-and-cote-divoire	Seven Nigerian Girls Rescued from Trafficking Networks	Seven Nigerian girls trafficked to Mali, Burkina Faso, and Côte d’Ivoire under false promises of employment have been rescued through a joint operation by GAHTO and NAPTIP. The survivors' stories reveal the dangers of trafficking networks that exploit vulnerable young Nigerians seeking better opportunities abroad.	Seven Nigerian girls trafficked to Mali, Burkina Faso, and Côte d’Ivoire under false promises of employment have been rescued through a coordinated operation involving the National Agency for the Prohibition of Trafficking in Persons (NAPTIP) and the Global Anti-Human Trafficking Organisation (GAHTO).\nThe survivors, drawn from Plateau, Cross River, and Edo States, recounted painful experiences of deception, exploitation, and coercion after accepting what they believed were legitimate job opportunities abroad.\nTheir stories expose the growing reach of trafficking networks that continue to target vulnerable Nigerians with promises of better lives and employment.\nPromises of Jobs Turned into Exploitation\nMany of the victims said they were promised jobs in boutiques, restaurants, phone accessory shops, domestic service, and other businesses.\nHowever, upon arriving in their destination countries, they discovered the offers were false.\nInstead, they were allegedly forced into prostitution and informed that they owed debts of up to 1.5 million CFA francs, which they were expected to repay through sex work.\nSandy Sophia, 22, from Plateau State, said she repeatedly sought assurance before travelling.\n“I asked countless times if it was prostitution, and they kept telling me it was not,” she said. “It was only after we arrived in Burkina Faso that they finally admitted the truth.”\nDreams Shattered Abroad\nRose, a 19-year-old graduate of Plateau State Polytechnic, said she accepted the offer hoping to support her education and family.\n“I was told I would be working in a boutique and helping with cooking,” she recalled.\nAlthough her mother initially expressed concern due to reports of trafficking, the family was repeatedly assured the opportunity was legitimate.\n“When we arrived in Mali, we discovered it was prostitution,” she said.\nSeveral survivors alleged that traffickers used fear and manipulation to maintain control, warning victims that refusing to comply or failing to repay their debts would result in spiritual attacks or mental illness.\nEscape, Survival, and Rescue\nEsther, one of the youngest survivors at 17, said she was recruited in Lagos with promises of domestic work.\nShe eventually escaped with the help of a Nigerian man from her community who lived in Mali.\nAnother 17-year-old survivor from Cross River State said she and her sister were recruited by a man identified as Peter, who promised jobs in family-owned businesses abroad.\nUpon arrival, they were allegedly informed that prostitution was the only way to repay the costs of transportation and migration.\nBlessing Inode Godwin from Cross River State shared a similar experience.\nAccording to her, she travelled believing she had secured employment in Mali but was instead forced into prostitution in a bar upon arrival.\nVictims said those who resisted were subjected to starvation, threats, intimidation, and other forms of coercion.\nPregnant Victims Endure Harsh Conditions\nTwo Edo State survivors, Augusta and Elizabeth, also narrated experiences of exploitation in Burkina Faso and Côte d’Ivoire.\nAugusta, 20, said she travelled after being persuaded by a relative who promised a better life abroad.\nUpon arrival, she discovered she was expected to engage in commercial sex work.\nWhen she refused, she alleged that she was assaulted and pressured to recruit other girls, including her own sister.\nShe further disclosed that she was pregnant before travelling and endured severe hardship, often struggling to access basic necessities such as food and water.\nSimilarly, Elizabeth said she travelled to Côte d’Ivoire expecting legitimate employment opportunities but found herself trapped in an exploitative environment.\nShe described being forced to surrender most of her earnings while receiving little support from those controlling her activities.\nElizabeth, who was also pregnant, said she feared for her life after being pressured to continue working despite her condition.\nA Second Chance at Life\nWith support from anti-trafficking advocates, sympathisers, NAPTIP, and GAHTO, several victims were eventually able to escape and return to Nigeria.\nGAHTO Founder Prosper Michael coordinated aspects of the rescue and repatriation process, helping reunite survivors with their families.\nExpressing relief after returning home, many of the survivors urged young Nigerians to thoroughly verify job offers and migration opportunities before travelling abroad.\n“I am very happy to be back home,” one survivor said. “I will advise other girls never to accept suspicious travel offers without proper verification.”\nThe Fight Against Human Trafficking Continues\nThe successful rescue operation highlights the ongoing threat posed by trafficking syndicates operating across West Africa.\nNAPTIP and GAHTO have reiterated their commitment to rescuing victims, dismantling trafficking networks, and raising awareness about the dangers of deceptive recruitment schemes.\nThe organisations also urged the public to report suspicious recruitment activities and encouraged young people to verify overseas opportunities through legitimate channels.\nInvestigations into the activities of suspected traffickers remain ongoing.	breaking	\N	\N	https://thesun.ng/trafficked-nigerian-girls-rescued-from-mali-burkina-faso-cote-divoire/	t	t	0	published	2026-06-10 11:43:30.940241	2	2026-06-10 11:43:30.941641	2026-06-10 11:43:30.941645
19	How GAHTO Rescued 7 Victims Trafficked To Mali, Burkina Faso & Côte d’Ivoire	how-gahto-rescued-7-victims-trafficked-to-mali-burkina-faso-cote-divoire	Victims Recount Ordeal in Mali, Burkina Faso, and Côte d’Ivoire	Seven Nigerian girls trafficked to Mali, Burkina Faso, and Côte d’Ivoire under false promises of employment have been rescued through a joint operation by GAHTO and NAPTIP. The survivors' stories reveal the dangers of trafficking networks that exploit vulnerable young Nigerians seeking better opportunities abroad.	Seven Nigerian Girls Rescued from Trafficking Networks in Mali, Burkina Faso, and Côte d’Ivoire\n\nSeven Nigerian girls trafficked to Mali, Burkina Faso, and Côte d’Ivoire under false promises of employment have been rescued through a coordinated operation involving the National Agency for the Prohibition of Trafficking in Persons (NAPTIP) and the Global Anti-Human Trafficking Organisation (GAHTO).\n\nThe survivors, drawn from Plateau, Cross River, and Edo States, recounted painful experiences of deception, exploitation, and coercion after accepting what they believed were legitimate job opportunities abroad.\n\nTheir stories expose the growing reach of trafficking networks that continue to target vulnerable Nigerians with promises of better lives and employment.\n\nPromises of Jobs Turned into Exploitation\n\nMany of the victims said they were promised jobs in boutiques, restaurants, phone accessory shops, domestic service, and other businesses.\n\nHowever, upon arriving in their destination countries, they discovered the offers were false.\n\nInstead, they were allegedly forced into prostitution and informed that they owed debts of up to 1.5 million CFA francs, which they were expected to repay through sex work.\n\nSandy Sophia, 22, from Plateau State, said she repeatedly sought assurance before travelling.\n\n“I asked countless times if it was prostitution, and they kept telling me it was not,” she said. “It was only after we arrived in Burkina Faso that they finally admitted the truth.”\n\nDreams Shattered Abroad\n\nRose, a 19-year-old graduate of Plateau State Polytechnic, said she accepted the offer hoping to support her education and family.\n\n“I was told I would be working in a boutique and helping with cooking,” she recalled.\n\nAlthough her mother initially expressed concern due to reports of trafficking, the family was repeatedly assured the opportunity was legitimate.\n\n“When we arrived in Mali, we discovered it was prostitution,” she said.\n\nSeveral survivors alleged that traffickers used fear and manipulation to maintain control, warning victims that refusing to comply or failing to repay their debts would result in spiritual attacks or mental illness.\n\nEscape, Survival, and Rescue\n\nEsther, one of the youngest survivors at 17, said she was recruited in Lagos with promises of domestic work.\n\nShe eventually escaped with the help of a Nigerian man from her community who lived in Mali.\n\nAnother 17-year-old survivor from Cross River State said she and her sister were recruited by a man identified as Peter, who promised jobs in family-owned businesses abroad.\n\nUpon arrival, they were allegedly informed that prostitution was the only way to repay the costs of transportation and migration.\n\nBlessing Inode Godwin from Cross River State shared a similar experience.\n\nAccording to her, she travelled believing she had secured employment in Mali but was instead forced into prostitution in a bar upon arrival.\n\nVictims said those who resisted were subjected to starvation, threats, intimidation, and other forms of coercion.\n\nPregnant Victims Endure Harsh Conditions\n\nTwo Edo State survivors, Augusta and Elizabeth, also narrated experiences of exploitation in Burkina Faso and Côte d’Ivoire.\n\nAugusta, 20, said she travelled after being persuaded by a relative who promised a better life abroad.\n\nUpon arrival, she discovered she was expected to engage in commercial sex work.\n\nWhen she refused, she alleged that she was assaulted and pressured to recruit other girls, including her own sister.\n\nShe further disclosed that she was pregnant before travelling and endured severe hardship, often struggling to access basic necessities such as food and water.\n\nSimilarly, Elizabeth said she travelled to Côte d’Ivoire expecting legitimate employment opportunities but found herself trapped in an exploitative environment.\n\nShe described being forced to surrender most of her earnings while receiving little support from those controlling her activities.\n\nElizabeth, who was also pregnant, said she feared for her life after being pressured to continue working despite her condition.\n\nA Second Chance at Life\n\nWith support from anti-trafficking advocates, sympathisers, NAPTIP, and GAHTO, several victims were eventually able to escape and return to Nigeria.\n\nGAHTO Founder Prosper Michael coordinated aspects of the rescue and repatriation process, helping reunite survivors with their families.\n\nExpressing relief after returning home, many of the survivors urged young Nigerians to thoroughly verify job offers and migration opportunities before travelling abroad.\n\n“I am very happy to be back home,” one survivor said. “I will advise other girls never to accept suspicious travel offers without proper verification.”\n\nThe Fight Against Human Trafficking Continues\n\nThe successful rescue operation highlights the ongoing threat posed by trafficking syndicates operating across West Africa.\n\nNAPTIP and GAHTO have reiterated their commitment to rescuing victims, dismantling trafficking networks, and raising awareness about the dangers of deceptive recruitment schemes.\n\nThe organisations also urged the public to report suspicious recruitment activities and encouraged young people to verify overseas opportunities through legitimate channels.\n\nInvestigations into the activities of suspected traffickers remain ongoing.	rescue-update	\N	\N	https://pmexpressng.com/how-gahto-rescued-7-victims-trafficked-to-mali-burkina-faso-cote-divoire/#google_vignette	t	t	0	published	2026-06-16 09:00:04.266402	2	2026-06-16 09:00:04.268709	2026-06-16 09:00:04.268714
20	NAPTIP, GAHTO Rescue Seven Nigerian Girls from Trafficking Networks Across West Africa	naptip-gahto-rescue-seven-nigerian-girls-from-trafficking-networks-across-west-africa	NAPTIP, GAHTO Rescue Seven Trafficked Nigerian Girls	Seven Nigerian girls trafficked to Mali, Burkina Faso, and Côte d’Ivoire under false promises of employment have been rescued through a joint operation by NAPTIP and GAHTO. Their stories reveal the harsh realities of exploitation, debt bondage, and deception used by trafficking networks across West Africa.	Seven Nigerian girls trafficked to Mali, Burkina Faso, and Côte d’Ivoire under the false promise of legitimate employment have been rescued and safely returned to Nigeria through a coordinated operation involving the National Agency for the Prohibition of Trafficking in Persons (NAPTIP) and the Global Anti-Human Trafficking Organisation (GAHTO).\n\nThe survivors, drawn from Plateau, Cross River, and Edo States, shared harrowing accounts of deception, coercion, and exploitation after being lured abroad with promises of jobs in boutiques, restaurants, domestic service, and other businesses.\n\nInstead of employment, they found themselves trapped in prostitution rings and debt bondage schemes that left them vulnerable and isolated.\n\nPromises of Opportunity Turned into Exploitation\n\nMany of the victims said recruiters assured them they would never be involved in sex work.\n\nOne of the survivors, 22-year-old Sandy Sophia from Plateau State, said she repeatedly questioned those arranging her trip before agreeing to travel.\n\n“I asked countless times if it was prostitution, and they kept telling me it was not,” she recalled. “It was only after we arrived in Burkina Faso that they admitted the truth.”\n\nSimilarly, Rose, a 19-year-old graduate of Plateau State Polytechnic, said she accepted the offer because she hoped to earn money to support her education and family.\n\n“I was told I would be working in a boutique and helping with cooking,” she said. “When we arrived in Mali, we discovered it was prostitution.”\n\nTheir experiences mirror a common tactic used by traffickers—offering attractive employment opportunities that later turn into exploitation.\n\nDebt Bondage, Threats, and Psychological Control\n\nSeveral survivors alleged that they were informed they owed debts of up to 1.5 million CFA francs and would have to repay the money through commercial sex work.\n\nAccording to their testimonies, victims who questioned the arrangement or demanded to return home faced threats, intimidation, starvation, and psychological manipulation.\n\nSome claimed traffickers used spiritual threats, warning that anyone who refused to cooperate or failed to repay their debt would suffer mental illness or other misfortunes.\n\nThe victims said they lived under constant surveillance and pressure while generating income for their handlers.\n\nEscape and Rescue\n\nAmong the survivors was Esther, 17, who said she was recruited in Lagos after being promised domestic work.\n\nShe eventually escaped with the help of a Nigerian man from her community who lived in Mali.\n\nAnother teenage survivor from Cross River State said she and her sister were recruited with promises of jobs in family-owned businesses abroad, only to discover they had been trafficked into prostitution.\n\nBless Inode Godwin also recounted being promised employment in Mali before finding herself trapped in a bar where she was expected to engage in commercial sex work.\n\nDespite the difficult conditions, several victims eventually managed to seek help, leading to their rescue and return home.\n\nPregnant Survivors Share Their Ordeal\n\nTwo Edo State survivors, Augusta and Elizabeth, also recounted their experiences after being rescued from Burkina Faso and Côte d’Ivoire.\n\nAugusta, 20, said she travelled after a relative convinced her family that she would secure a better future abroad.\n\nUpon arrival, she discovered she was expected to engage in prostitution.\n\nWhen she refused, she alleged that she was assaulted and pressured to recruit other girls, including her younger sister.\n\nShe further disclosed that she was pregnant before travelling and endured severe hardship while abroad, often struggling to afford food and water.\n\nElizabeth described a similar experience.\n\nShe said she travelled expecting legitimate work opportunities but soon realised the promised jobs did not exist.\n\nAccording to her, she was forced to surrender most of her earnings and pressured to continue working despite being pregnant.\n\nBoth women eventually escaped with the help of sympathisers and anti-trafficking advocates.\n\nA Call for Greater Vigilance\n\nDuring the handover of some of the rescued victims, community leaders expressed concern over the increasing prevalence of human trafficking involving young Nigerian women.\n\nThey called for stronger collaboration between government agencies, community organisations, and civil society groups to prevent vulnerable young people from falling victim to traffickers.\n\nThe survivors also urged Nigerians seeking opportunities abroad to thoroughly verify job offers and travel arrangements before leaving the country.\n\nOne victim expressed relief at being reunited with her family and warned that many attractive offers abroad conceal trafficking and exploitation schemes.\n\nGAHTO Reaffirms Commitment\n\nThe rescue operation was facilitated by GAHTO following a request from NAPTIP’s Benin Zonal Command, while the victims were formally received by NAPTIP officials upon their return to Nigeria.\n\nGAHTO reaffirmed its commitment to combating human trafficking, supporting rescue operations, and helping vulnerable Nigerians trapped in exploitation networks across Africa and beyond.\n\nThe organisation also encouraged families and communities to remain vigilant and promptly report suspicious recruitment activities to relevant authorities.\n\nInvestigations into the activities of the suspected traffickers are ongoing.	rescue-update	\N	\N	https://thenationonlineng.net/naptip-gahto-rescue-seven-nigerian-girls-forced-into-prostitution-in-west-africa/	t	t	0	published	2026-06-16 09:05:48.083783	2	2026-06-16 09:05:48.084305	2026-06-16 09:05:48.084308
21	Even While Pregnant, We Were Forced to Sleep with Clients’  Survivors Recount Trafficking Horror	even-while-pregnant-we-were-forced-to-sleep-with-clients-survivors-recount-trafficking-horror	Survivors Recount Trafficking Horror in West Africa	Seven Nigerian girls rescued from trafficking networks in Mali and Burkina Faso have shared harrowing stories of deception, exploitation, and abuse. Lured abroad with promises of legitimate jobs, they instead faced forced prostitution, debt bondage, and coercion before being rescued by GAHTO and NAPTIP	Seven young Nigerian women and girls rescued from trafficking networks in Mali and Burkina Faso have shared chilling accounts of deception, exploitation, and abuse, revealing how trusted friends, relatives, and community members lured them into modern-day slavery under the guise of legitimate employment.\n\nThe survivors were rescued through the efforts of the Global Anti-Human Trafficking Organisation (GAHTO), working alongside the National Agency for the Prohibition of Trafficking in Persons (NAPTIP) and authorities in the affected countries.\n\nTheir stories expose a disturbing reality: many trafficking victims are not recruited by strangers, but by people they know and trust.\n\nThe Promise of a Better Life\n\nFor 22-year-old Sunday Sofia, the journey began with hope.\n\nWorking as a maid and sales assistant in Lagos for a modest income, she dreamed of earning more to support her family and younger siblings.\n\nWhen a friend introduced her to what appeared to be a better opportunity abroad, she accepted without hesitation.\n\n“It was one of my friends who told me she had secured another job for me,” Sofia recalled. “We were told we were going to work as housekeepers.”\n\nInstead, she found herself trapped in Mali.\n\nHer story mirrors those of Blessing Samson, Esther Gyang, Odey Blessing, and Rose Pam, who were allegedly recruited by agents posing as trusted helpers and job facilitators.\n\nThe girls said they were promised jobs in boutiques, restaurants, and phone accessory shops.\n\n“We asked repeatedly if it was prostitution,” Odey Blessing recalled. “They assured us it was not.”\n\nThe Moment Everything Changed\n\nThe dream collapsed shortly after they crossed the border.\n\nInstead of workplaces, the girls were taken to bars and locations where other trafficked women were already operating.\n\n“The following day, reality became impossible to ignore,” Odey said. “They told us there was no boutique, no phone shop. They said it was prostitution.”\n\nThe girls pleaded to return home but were told they had no choice.\n\nAccording to their testimonies, each victim was informed that she owed approximately 1.5 million CFA francs and would have to repay the debt through sex work.\n\nWhat followed were weeks and months of exploitation, fear, and coercion.\n\nSome victims reported being forced to serve multiple clients daily while struggling to repay debts that never seemed to reduce.\n\nExploitation Without Mercy\n\nThe survivors described conditions that stripped them of dignity and freedom.\n\nAccording to Odey, there were no exceptions—not even during menstruation.\n\n“Even when we were on our menstrual cycle, we were still forced to sleep with men,” she said.\n\nTraffickers allegedly relied on both physical and psychological control.\n\nSeveral victims said they were threatened with spiritual attacks, insanity, or death if they attempted to escape.\n\n“Our madam kept telling us we would run mad if we refused to work or tried to leave,” one survivor said.\n\nThe threats were designed to exploit fear and keep victims trapped.\n\nPregnancy Offered No Protection\n\nAmong the most disturbing accounts were those of Augusta Akoghamhen and Elizabeth, who were trafficked to Burkina Faso while pregnant.\n\nAugusta said she was recruited through a trusted family connection and promised domestic work for foreign employers.\n\nBecause the offer came from someone known to the family, there was little reason to suspect danger.\n\nHowever, after a week-long journey, she discovered the promised job did not exist.\n\n“That same evening we arrived, they forced us to start working,” she recalled. “The work was prostitution.”\n\nDespite being pregnant, Augusta said she was expected to continue servicing clients and surrendering most of her earnings.\n\n“Whenever I refused because I was unwell, my boss attacked me,” she said.\n\nElizabeth shared a similar experience.\n\n“If they had told me it was prostitution, I would never have travelled,” she said. “Even while pregnant, they expected us to continue working until we gave birth.”\n\nShe also described being treated as a commodity in disputes between traffickers, with decisions about her future made without her consent.\n\nThe Road to Freedom\n\nDespite the threats and abuse, some victims secretly sought help.\n\nSofia recalled meeting a man from her village who lived and worked in Mali.\n\nWhen he learned of their situation, he promised to assist.\n\nHis intervention eventually connected the victims to GAHTO, triggering a rescue effort that brought them back to Nigeria.\n\nAugusta's rescue began after she secretly contacted her father, who helped alert anti-trafficking advocates and authorities.\n\nWorking alongside NAPTIP and foreign partners, GAHTO coordinated rescue operations that ultimately secured the freedom of the victims.\n\nMost of the girls returned home with little more than the clothes they were wearing.\n\nSome lost personal belongings, while others worked for months without receiving any compensation.\n\nYet they all returned with something priceless—their freedom.\n\nA Warning to Young Nigerians\n\nThe survivors are now using their experiences to warn others about the dangers of unverified job offers and migration opportunities.\n\nTheir stories demonstrate how traffickers increasingly exploit trust, family relationships, and economic hardship to recruit victims.\n\nToday, many of the rescued girls hope to rebuild their lives through education, vocational training, and honest work.\n\nFor Sofia, that means returning to hairdressing and completing the apprenticeship she abandoned.\n\nFor others, it means reconnecting with family and pursuing dreams that trafficking nearly destroyed.\n\nTheir message is simple: no promise of quick wealth or overseas opportunity is worth the cost of freedom.\n\nThe Fight Continues\n\nHuman trafficking remains one of the most significant challenges facing vulnerable young Nigerians.\n\nAccording to NAPTIP, hundreds of trafficking victims continue to be rescued annually, while thousands more remain at risk through recruitment scams and cross-border trafficking networks.\n\nAs investigations continue, anti-trafficking advocates are calling for stronger public awareness, improved economic opportunities, and greater vigilance from families and communities.\n\nFor the survivors, the rescue marks not just an end to their ordeal, but the beginning of a new chapter.	breaking	https://cdn.vanguardngr.com/wp-content/uploads/2026/06/pros-.jpg	\N	https://www.vanguardngr.com/2026/06/even-while-pregnant-we-were-forced-to-sleep-with-clients-survivors-recount-sex-trafficking/	t	t	0	published	2026-06-21 16:56:42.978833	2	2026-06-21 16:56:42.980407	2026-06-21 16:56:42.98041
\.


--
-- Data for Name: notification_logs; Type: TABLE DATA; Schema: public; Owner: gahtosuperadmin
--

COPY public.notification_logs (id, title, message, type, is_read, related_type, related_id, created_at, updated_at) FROM stdin;
1	Urgent report submitted	Anonymous reporter submitted a suspected trafficking report: moving some ladies in vehickes	report	t	report	1	2026-04-14 19:58:45.920905	2026-04-15 08:33:58.498032
2	Urgent report submitted	Anonymous reporter submitted a suspected trafficking report: test test test test	report	t	report	2	2026-04-15 09:52:08.133799	2026-04-17 08:03:04.310161
3	New report submitted	Busayo Folorunso submitted a attempted trafficking report: I saw some girls trying to run	report	t	report	3	2026-04-15 09:58:17.923228	2026-04-17 08:03:04.310166
4	New contact message received	XHnTXuDiBZMrRuvCshfTpEns (w.e.z.ak.i.g.e.s7.1@gmail.com) sent a new message: JwaNlOZZTNBhKVuLPiFB	contact_message	t	contact_message	1	2026-05-06 17:22:58.459667	2026-05-10 11:41:31.432108
5	Urgent report submitted	Anonymous reporter submitted a suspected trafficking report: kkkkkkkkkk	report	t	report	4	2026-05-27 21:58:53.06399	2026-06-01 18:38:50.514176
6	New contact message received	tuexTGJgtTENdxXJxvOXcu (j.ut.i.j.oday.u.q.e0.4@gmail.com) sent a new message: srqATICysLlgJZjR	contact_message	t	contact_message	2	2026-05-29 06:28:15.181817	2026-06-01 18:38:50.514181
7	New contact message received	oqiOPWqPtyPhPnPV (u.p.ed.if.i.j.480@gmail.com) sent a new message: uinnNKBkRUsFrbRbFmF	contact_message	t	contact_message	3	2026-06-03 08:28:27.466481	2026-06-06 17:11:52.341772
8	Urgent report submitted	Anonymous reporter submitted a suspected trafficking report: A Trafficking victim to Mali	report	f	report	5	2026-06-10 10:31:54.429741	2026-06-10 10:31:54.429746
9	New contact message received	John Bidemi (drjbolat@gmail.com) sent a new message: I'm messaging to know how fast is rescuing victims of trafficking	contact_message	f	contact_message	4	2026-06-10 10:35:59.528356	2026-06-10 10:35:59.528362
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: gahtosuperadmin
--

COPY public.reports (id, case_type, urgency, description, location, incident_time, additional_notes, is_anonymous, reporter_name, reporter_email, reporter_phone, status, ai_severity_score, ai_summary, escalation_status, created_at, updated_at, evidence_url) FROM stdin;
3	Attempted Trafficking	Low	I saw some girls trying to run	6.447400, 3.390300	8am	\N	f	Busayo Folorunso	busayo.joshua.folorunso@gmail.com	9121511485	resolved	90	If this is happening right now and it feels dangerous, please move to a safer place first and call emergency services now.\n\nIf you can’t safely call, use a quick report option:\n- U.S. National Human Trafficking Hotline: call 1-888-373-7888 or text 233733\n- If you’re elsewhere, tell me your country and I’ll give the right number\n\nWhat to do right now, only if safe:\n- Do not confront anyone\n- Note location, time, vehicle, license plate, descriptions, and direction they went\n- If the girls reached you and ask for help, keep them with you in a public, visible place and call emergency services/hotline\n\nIf you want, I can help you make a short report message you can send right now.	pending	2026-04-15 09:58:11.659391	2026-04-22 20:14:30.956307	/uploads/0ce88284dd614eab9c794b451c1b4b9b_live-video-1776246951285.webm
2	Suspected Trafficking	Urgent	test test test test	7.623788, 5.223733	9pm	testting thest	t	\N	\N	\N	resolved	90	Hi — I’m here. If this was a test, that’s okay.\n\nIf you need help with a trafficking or exploitation situation right now, reply with just one word:\n- **SAFE** if you can talk\n- **UNSAFE** if someone may see your messages\n\nIf there’s immediate danger and you can do so safely, contact local emergency services now. If calling isn’t safe, I can help you plan the safest next step or a low-risk way to report.	pending	2026-04-15 09:51:56.321271	2026-04-22 20:14:39.340101	/uploads/5fdda48a79cf43b7928541b1e5794c47_live-video-1776246690126.webm
1	Suspected Trafficking	Urgent	moving some ladies in vehickes	6.447400, 3.390300	\N	they are moving fast	t	\N	\N	\N	resolved	\N	\N	pending	2026-04-14 19:58:45.909076	2026-04-25 11:54:31.487322	\N
4	Suspected Trafficking	Urgent	kkkkkkkkkk	\N	\N	\N	t	\N	\N	\N	new	90	I’m here. If that was a test or you couldn’t type safely, you can reply with just one word or number.\n\nIf you may be in danger right now:\n- Go to a safer place if you can.\n- Call emergency services now if you can do so safely.\n- If calling is not safe, use GAHTO’s report options or send a short message like:\n  - “help”\n  - “unsafe”\n  - “call me”\n  - your city/location\n\nIf you want, send:\n- **1** = immediate danger\n- **2** = need advice\n- **3** = report someone else\n- **4** = not sure / just testing\n\nIf you can, share your country so I can point you to the safest next step.	pending	2026-05-27 21:58:41.429053	2026-05-27 21:58:53.056546	\N
5	Suspected Trafficking	Urgent	A Trafficking victim to Mali	Bamako	May	\N	t	\N	\N	\N	new	90	If someone may be a trafficking victim in Mali, the priority is **immediate safety**.\n\n**If they are in danger now:**\n- **Move to a safer place** if possible: a public area, clinic, police/gendarmerie post, embassy/consulate, or trusted NGO/church/mosque.\n- If **calling could put them at risk**, use a **safe report form** instead: **https://gahto.world/report/**  \n  You can submit details for yourself or someone else.\n\n**Emergency options in Mali**\n- **Police/Gendarmerie:** try local emergency services if safe to do so.\n- **Embassy/Consulate:** if the victim is a foreign national, contact their embassy/consulate urgently.\n- **Medical help:** go to the nearest clinic/hospital if there are injuries, illness, pregnancy concerns, or sexual assault.\n\n**What to send in a report**\n- Person’s **name or nickname**\n- **Current location** or last known location\n- **Who is controlling them** (name, phone, vehicle, workplace, social media)\n- Whether there is **violence, threats, locked confinement, passport confiscation, or forced sex/work**\n- Best **safe contact method** and times\n\n**Important safety steps**\n- **Do not confront** the trafficker yourself.\n- **Do not share plans** where the trafficker might see them.\n- If using a phone, consider **deleting call/history** only if it is safe and not suspicious.\n- Keep any **photos, messages, addresses, plate numbers, receipts** if this can be done safely.\n\nIf you want, I can help you write a **short urgent report** right now.  \nReply with any details you know:\n1. **City/location in Mali**  \n2. **Is the victim in immediate danger?**  \n3. **Safe phone/email/WhatsApp**  \n4. **What happened / who is controlling them**	pending	2026-06-10 10:31:34.862242	2026-06-10 10:31:54.337957	/uploads/9833b54865944c3baa7f110e88720edd_live-video-1781087471620.webm
\.


--
-- Data for Name: site_settings; Type: TABLE DATA; Schema: public; Owner: gahtosuperadmin
--

COPY public.site_settings (id, key, value, description, is_public, created_at, updated_at) FROM stdin;
5	support_email	info@gahto.org	Support email address	t	2026-04-12 16:15:08.655542	2026-04-12 16:15:08.655544
2	emergency_phone	0805 050 3535	Emergency reporting phone number	t	2026-04-12 16:15:08.65553	2026-04-13 04:41:15.534585
6	facebook_url	https://www.facebook.com/globalantihumantraffickingorganization	Official Facebook page	t	2026-04-12 16:15:08.655546	2026-04-13 04:44:12.529133
7	twitter_url	https://x.com/GlobalAntiHT?t=j-V9QBzznVCRxSLMrBfLTA&s=09	Official Twitter/X page	t	2026-04-12 16:15:08.655551	2026-04-13 04:44:25.595844
4	mali_office_phone	+22371 402 809	Mali office phone line	t	2026-04-12 16:15:08.655538	2026-04-13 04:47:41.363706
1	whatsapp_number	+234805 050 3535	Primary WhatsApp contact line	t	2026-04-12 16:15:08.65552	2026-06-04 17:32:21.447956
3	nigeria_office_phone	+234805 050 3535	Nigeria office phone line	t	2026-04-12 16:15:08.655534	2026-06-04 17:33:01.893835
8	intro_video_url	/vid/intro_vid.mp4	URL of the intro video	t	2026-06-06 17:03:03.086073	2026-06-06 17:03:03.08608
\.


--
-- Name: admin_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gahtosuperadmin
--

SELECT pg_catalog.setval('public.admin_users_id_seq', 2, true);


--
-- Name: campaigns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gahtosuperadmin
--

SELECT pg_catalog.setval('public.campaigns_id_seq', 1, true);


--
-- Name: contact_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gahtosuperadmin
--

SELECT pg_catalog.setval('public.contact_messages_id_seq', 4, true);


--
-- Name: donations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gahtosuperadmin
--

SELECT pg_catalog.setval('public.donations_id_seq', 12, true);


--
-- Name: news_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gahtosuperadmin
--

SELECT pg_catalog.setval('public.news_posts_id_seq', 21, true);


--
-- Name: notification_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gahtosuperadmin
--

SELECT pg_catalog.setval('public.notification_logs_id_seq', 9, true);


--
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gahtosuperadmin
--

SELECT pg_catalog.setval('public.reports_id_seq', 5, true);


--
-- Name: site_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gahtosuperadmin
--

SELECT pg_catalog.setval('public.site_settings_id_seq', 8, true);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: contact_messages contact_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.contact_messages
    ADD CONSTRAINT contact_messages_pkey PRIMARY KEY (id);


--
-- Name: donations donations_pkey; Type: CONSTRAINT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_pkey PRIMARY KEY (id);


--
-- Name: news_posts news_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.news_posts
    ADD CONSTRAINT news_posts_pkey PRIMARY KEY (id);


--
-- Name: notification_logs notification_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.notification_logs
    ADD CONSTRAINT notification_logs_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: site_settings site_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: gahtosuperadmin
--

ALTER TABLE ONLY public.site_settings
    ADD CONSTRAINT site_settings_pkey PRIMARY KEY (id);


--
-- Name: ix_admin_users_email; Type: INDEX; Schema: public; Owner: gahtosuperadmin
--

CREATE UNIQUE INDEX ix_admin_users_email ON public.admin_users USING btree (email);


--
-- Name: ix_admin_users_id; Type: INDEX; Schema: public; Owner: gahtosuperadmin
--

CREATE INDEX ix_admin_users_id ON public.admin_users USING btree (id);


--
-- Name: ix_campaigns_id; Type: INDEX; Schema: public; Owner: gahtosuperadmin
--

CREATE INDEX ix_campaigns_id ON public.campaigns USING btree (id);


--
-- Name: ix_campaigns_slug; Type: INDEX; Schema: public; Owner: gahtosuperadmin
--

CREATE UNIQUE INDEX ix_campaigns_slug ON public.campaigns USING btree (slug);


--
-- Name: ix_contact_messages_id; Type: INDEX; Schema: public; Owner: gahtosuperadmin
--

CREATE INDEX ix_contact_messages_id ON public.contact_messages USING btree (id);


--
-- Name: ix_donations_id; Type: INDEX; Schema: public; Owner: gahtosuperadmin
--

CREATE INDEX ix_donations_id ON public.donations USING btree (id);


--
-- Name: ix_news_posts_id; Type: INDEX; Schema: public; Owner: gahtosuperadmin
--

CREATE INDEX ix_news_posts_id ON public.news_posts USING btree (id);


--
-- Name: ix_news_posts_slug; Type: INDEX; Schema: public; Owner: gahtosuperadmin
--

CREATE UNIQUE INDEX ix_news_posts_slug ON public.news_posts USING btree (slug);


--
-- Name: ix_notification_logs_id; Type: INDEX; Schema: public; Owner: gahtosuperadmin
--

CREATE INDEX ix_notification_logs_id ON public.notification_logs USING btree (id);


--
-- Name: ix_reports_id; Type: INDEX; Schema: public; Owner: gahtosuperadmin
--

CREATE INDEX ix_reports_id ON public.reports USING btree (id);


--
-- Name: ix_site_settings_id; Type: INDEX; Schema: public; Owner: gahtosuperadmin
--

CREATE INDEX ix_site_settings_id ON public.site_settings USING btree (id);


--
-- Name: ix_site_settings_key; Type: INDEX; Schema: public; Owner: gahtosuperadmin
--

CREATE UNIQUE INDEX ix_site_settings_key ON public.site_settings USING btree (key);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO gahtosuperadmin;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO gahtosuperadmin;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO gahtosuperadmin;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO gahtosuperadmin;


--
-- PostgreSQL database dump complete
--

\unrestrict 1wSjBV2e1BKatp1WoaxjsWzIgHWQ05DvqQ4PQdaojoS1k5EIcRCalJRTkSbqTQC

