SQLite format 3   @       	           �                                                 .[0� � ���?�                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   � �                          � v    lw##�tableprofesseursprofesseursCREATE TABLE professeurs (
    nomProf VARCHAR(30) PRIMARY KEY NOT NULL
)^y�tablesallessallesCREATE TABLE salles (
    nomSalle VARCHAR(30) PRIMARY KEY NOT NULL
)+z? indexsqlite_autoindex_salles_1salles     5xI# indexsqlite_autoindex_professeurs_1professeurs       �+u++�tableprevisionnelEDTprevisionnelEDTCREATE TABLE previsionnelEDT (
    uuid VARCHAR(36) PRIMARY KEY NOT NULL,
    numSemaine INTEGER,
    tab VARCHAR(15),
    typeDeCours VARCHAR(20),
    nomModule VARCHAR(20),
    prof VARCHAR(20),
    salles VARCHAR(40),
    groupe VARCHAR(20),
    dureeEnMin INTEGER,
    nomDuJour VARCHAR(20) DEFAULT "",
    horaire VARCHAR(20) DEFAULT "",
    salleRetenue VARCHAR(20) DEFAULT ""
)=vQ+ indexsqlite_autoindex_previsionnelEDT_1previsionnelEDT   �    	�                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ,
   4� 
f

����� 	�H��R��	p�Q3
z�({
=\	G�g)�	��4���
�q��	�
�]�>�	�                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             (U0ea50c46-d2c4-40dc-b44f-5cdd104c4b334(U141a8061-c86c-4278-a149-f33ec3ece9d13(U931b6eb6-655f-4b41-a263-ebc9a766b31a2(U6af1eb36-c12b-49d9-a9c2-5e2e8bef8f8b1(U4d042ab8-f152-4c96-8adc-f94437a755dd0(U64db3bc2-c33b-4dbd-b847-d031e3544fbb/(Ue6abd841-28b9-4918-9148-bb4088e1a94c.(U3c821ae3-03dc-4c27-8b37-7088ecc2b0fb-(U1a6af61a-ae87-4502-ae1e-eef23ef46bcd,(Ub5106c17-f8da-4ed1-ba8a-006644dea03b+(U7a091afb-1224-47fb-8da1-15695fae2b1b*(U43671fd2-beef-4f18-ba15-9e1bb30921eb)(Uf0b3c49c-b39e-4e98-b653-fb0d45d36006((U22c8d151-7351-4a20-b2e5-59f4fe9b55ab'(Ufc32930a-e372-49ab-b263-647d1f2a653f&(U05525112-0ef3-44d0-950d-1cdec5dca13b%(U6ff0a363-525a-4603-b81a-8e5717bfc5e8$(U0207aa62-4c1d-4f22-ad84-a41f1e9cb18d#(Udc573e64-095d-4b42-bb6d-1e6294697620"(U08f59247-ff39-4cb5-927f-8c58fb68642c!(Uf226c38f-4690-451f-8d83-5e4f7c1a3ee5 (U633dd230-b77d-4f9f-95c3-eb17f0f31ac9(U4e50d36c-3f42-4981-914a-54f043c063bc(U72c33af9-87c3-426f-88f2-0df752b3ff95(Ud79fd743-1dff-4ed7-a80c-0a6cdc58a16b(Ue6e61475-349a-49e6-949e-ac135d8e293f(Uaaf673b5-55d1-44d8-9ef4-bd981d8cb6cf(U1c934d9c-a9ec-47dd-b119-8186bf17cec0(Ua98d7bd6-f2ac-4901-bc88-4ef49a0aede3(U3acddcaf-ffc2-4024-8db9-6e49e01deb90(U6b16e6b2-e787-4f6e-8f99-538fea9603e8(U29694110-15dc-4584-967f-f8d7493af538(U3c35a3a5-4503-442c-b4ca-fd7a5ddc216d(Uba26ed0b-b20f-4b38-b014-2e9f599ab219(U4395e4ba-3d8c-4fca-8f2b-dc8ea7a6c09d(U26152cbc-6bcb-4fe9-8612-ea05b4a3b5f1(Ue4bc4dbe-9f94-472b-bb26-6c825906ac96(Uf68ef56e-3424-4e61-b84c-30ee558f1789(Ud1825d54-497a-47a9-adb5-c759389b81ee(U6ac86951-1654-4805-994a-72f29a2b9a7e(U49cfde9d-d1c4-4db1-87ce-29ab5f43b2cc(Uf73fe481-32f5-41e2-97e7-a9668c8399c0(U9f15b790-084d-4d7a-ab5d-3d4e2c9b3252
(Ubddcd536-b62d-41df-a871-f3f780480b4a	(Ud62b625d-5766-4304-bbcc-7df248d6dc51(U180ce22c-4ff6-4526-9c44-028b341ba4e3(U3234e910-83a1-43df-8319-fdc915d1dd8c(Ud0dca83e-d3bf-44c7-bbe5-462241674723(Uf32c8b10-b0c2-43bb-9fb6-dff56418764a(U3798b43d-c981-468a-9878-112791ff263e(U461fc566-d0e1-40b3-b4f8-d99e9415cf92'U	fb396bdb-37a7-454c-8080-1d1ffb2d63c8   � �������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
belhommelibinesamyn	lanchonlepesteur	roubaud
Belhomme   � �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                C1
   � �������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      belhomme
libine	samynlanchonlepesteurroubaud	Belhomme
   � �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                	C1   , e �P��B��1�{ �j
�
Y	�	�	H��7��&�p�_�N��=��,�v � e     Y,U1a6af61a-ae87-4502-ae1e-eef23ef46bcd&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY+Ub5106c17-f8da-4ed1-ba8a-006644dea03b&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY*U7a091afb-1224-47fb-8da1-15695fae2b1b&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY)U43671fd2-beef-4f18-ba15-9e1bb30921eb&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY(Uf0b3c49c-b39e-4e98-b653-fb0d45d36006&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY'U22c8d151-7351-4a20-b2e5-59f4fe9b55ab&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY&Ufc32930a-e372-49ab-b263-647d1f2a653f&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY%U05525112-0ef3-44d0-950d-1cdec5dca13b&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY$U6ff0a363-525a-4603-b81a-8e5717bfc5e8&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY#U0207aa62-4c1d-4f22-ad84-a41f1e9cb18d&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY"Udc573e64-095d-4b42-bb6d-1e6294697620&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY!U08f59247-ff39-4cb5-927f-8c58fb68642c&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY Uf226c38f-4690-451f-8d83-5e4f7c1a3ee5&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU633dd230-b77d-4f9f-95c3-eb17f0f31ac9&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU4e50d36c-3f42-4981-914a-54f043c063bc&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU72c33af9-87c3-426f-88f2-0df752b3ff95&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYUd79fd743-1dff-4ed7-a80c-0a6cdc58a16b&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYUe6e61475-349a-49e6-949e-ac135d8e293f&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYUaaf673b5-55d1-44d8-9ef4-bd981d8cb6cf&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU1c934d9c-a9ec-47dd-b119-8186bf17cec0&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYUa98d7bd6-f2ac-4901-bc88-4ef49a0aede3&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU3acddcaf-ffc2-4024-8db9-6e49e01deb90&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU6b16e6b2-e787-4f6e-8f99-538fea9603e8&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU29694110-15dc-4584-967f-f8d7493af538&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU3c35a3a5-4503-442c-b4ca-fd7a5ddc216d&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYUba26ed0b-b20f-4b38-b014-2e9f599ab219&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU4395e4ba-3d8c-4fca-8f2b-dc8ea7a6c09d&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU26152cbc-6bcb-4fe9-8612-ea05b4a3b5f1&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYUe4bc4dbe-9f94-472b-bb26-6c825906ac96&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYUf68ef56e-3424-4e61-b84c-30ee558f1789&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYUd1825d54-497a-47a9-adb5-c759389b81ee&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU6ac86951-1654-4805-994a-72f29a2b9a7e&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU49cfde9d-d1c4-4db1-87ce-29ab5f43b2cc&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYUf73fe481-32f5-41e2-97e7-a9668c8399c0&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY
U9f15b790-084d-4d7a-ab5d-3d4e2c9b3252&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY	Ubddcd536-b62d-41df-a871-f3f780480b4a&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYUd62b625d-5766-4304-bbcc-7df248d6dc51&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU180ce22c-4ff6-4526-9c44-028b341ba4e3&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYU3234e910-83a1-43df-8319-fdc915d1dd8c&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYUd0dca83e-d3bf-44c7-bbe5-462241674723&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiYUf32c8b10-b0c2-43bb-9fb6-dff56418764a&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiVU3798b43d-c981-468a-9878-112791ff263e&GIM-1A-FITDMathsBelhommeC1Gim-1a-fiVU461fc566-d0e1-40b3-b4f8-d99e9415cf92&GIM-1A-FITDMathsBelhommeC1Gim-1a-fiVUfb396bdb-37a7-454c-8080-1d1ffb2d63c8&GIM-1A-FITDMathsBelhommeC1Gim-1a-fi   ( �J��9��(                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                Y4U0ea50c46-d2c4-40dc-b44f-5cdd104c4b33&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY3U141a8061-c86c-4278-a149-f33ec3ece9d1&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY2U931b6eb6-655f-4b41-a263-ebc9a766b31a&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY1U6af1eb36-c12b-49d9-a9c2-5e2e8bef8f8b&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY0U4d042ab8-f152-4c96-8adc-f94437a755dd&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY/U64db3bc2-c33b-4dbd-b847-d031e3544fbb&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY.Ue6abd841-28b9-4918-9148-bb4088e1a94c&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fiY-U3c821ae3-03dc-4c27-8b37-7088ecc2b0fb&GIM-1A-FITDMathsBelhommeC1,C2Gim-1a-fi