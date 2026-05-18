-- ─── Migration 026: Alberta Schools & Divisions ─────────────────────
-- Populates divisions and schools tables with Alberta Education data.
-- Source: Alberta Open Government Portal (2024/2025 final enrolment)
-- https://open.alberta.ca/dataset/student-enrolment-by-school-authority-and-grade-level
--
-- Inserts 90 divisions + 1 synthetic 'Alberta Independent Schools' division
-- Inserts 2318 schools
--
-- IDEMPOTENT: deterministic UUIDs, ON CONFLICT (id) DO NOTHING.

-- ─── Divisions ────────────────────────────────────────────────────────

-- Public: The Clearview School Division (2441 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'The Clearview School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 2441. Code: 0052'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Chinook's Edge School Division (11236 students, metro)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'The Chinook''s Edge School Division',
  'metro',
  'free',
  'Alberta Public division. Enrolment: 11236. Code: 0053'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Wolf Creek School Division (7816 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'The Wolf Creek School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 7816. Code: 0054'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Westwind School Division (4621 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'The Westwind School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 4621. Code: 0056'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Peace Wapiti School Division (6333 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'The Peace Wapiti School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 6333. Code: 0177'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Prairie Rose School Division (3863 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'The Prairie Rose School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 3863. Code: 0195'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Horizon School Division (3495 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'The Horizon School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 3495. Code: 1045'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Peace River School Division (3081 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'The Peace River School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 3081. Code: 1070'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Grande Yellowhead School Division (4539 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'The Grande Yellowhead School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 4539. Code: 1085'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Sturgeon School Division (5223 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'The Sturgeon School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 5223. Code: 1110'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Prairie Land School Division (3782 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'The Prairie Land School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 3782. Code: 1115'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Livingstone Range School Division (3747 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'The Livingstone Range School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 3747. Code: 1135'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Buffalo Trail School Division (3749 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'The Buffalo Trail School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 3749. Code: 1155'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Pembina Hills School Division (5335 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'The Pembina Hills School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 5335. Code: 1175'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Foothills School Division (7931 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'The Foothills School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 7931. Code: 1180'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Rocky View School Division (29225 students, metro)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'The Rocky View School Division',
  'metro',
  'free',
  'Alberta Public division. Enrolment: 29225. Code: 1190'
) ON CONFLICT (id) DO NOTHING;

-- Public: The High Prairie School Division (2917 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '25e56639-065c-524c-b7f0-fe4f648e84cd',
  'The High Prairie School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 2917. Code: 1220'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Northern Lights School Division (5954 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'The Northern Lights School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 5954. Code: 1245'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Fort Vermilion School Division (4124 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'The Fort Vermilion School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 4124. Code: 1250'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Northland School Division (1545 students, medium)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'The Northland School Division',
  'medium',
  'free',
  'Alberta Public division. Enrolment: 1545. Code: 1280'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Wild Rose School Division (4577 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'The Wild Rose School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 4577. Code: 1325'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Grasslands School Division (3548 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'The Grasslands School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 3548. Code: 2045'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Wetaskiwin School Division (3268 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'The Wetaskiwin School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 3268. Code: 2115'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Aspen View School Division (2639 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'The Aspen View School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 2639. Code: 2125'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Golden Hills School Division (8742 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'The Golden Hills School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 8742. Code: 2155'
) ON CONFLICT (id) DO NOTHING;

-- Public: The St. Paul School Division (3633 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'The St. Paul School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 3633. Code: 2185'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Elk Island School Division (17939 students, metro)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'The Elk Island School Division',
  'metro',
  'free',
  'Alberta Public division. Enrolment: 17939. Code: 2195'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Black Gold School Division (13487 students, metro)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'The Black Gold School Division',
  'metro',
  'free',
  'Alberta Public division. Enrolment: 13487. Code: 2245'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Palliser School Division (9660 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'The Palliser School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 9660. Code: 2255'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Northern Gateway School Division (4773 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'The Northern Gateway School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 4773. Code: 2275'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Battle River School Division (5841 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'The Battle River School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 5841. Code: 2285'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Parkland School Division (12776 students, metro)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'The Parkland School Division',
  'metro',
  'free',
  'Alberta Public division. Enrolment: 12776. Code: 2305'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Edmonton School Division (120918 students, metro)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'The Edmonton School Division',
  'metro',
  'free',
  'Alberta Public division. Enrolment: 120918. Code: 3020'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Calgary School Division (142511 students, metro)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'The Calgary School Division',
  'metro',
  'free',
  'Alberta Public division. Enrolment: 142511. Code: 3030'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Lethbridge School Division (12279 students, metro)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'The Lethbridge School Division',
  'metro',
  'free',
  'Alberta Public division. Enrolment: 12279. Code: 3040'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Medicine Hat School Division (6837 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'The Medicine Hat School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 6837. Code: 3050'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Canadian Rockies School Division (2094 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '3c0ae25b-d630-503f-8c66-9d4cc272d36c',
  'The Canadian Rockies School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 2094. Code: 3065'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Red Deer School Division (11388 students, metro)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'dca610fd-a0df-5e89-b322-0800619da089',
  'The Red Deer School Division',
  'metro',
  'free',
  'Alberta Public division. Enrolment: 11388. Code: 3070'
) ON CONFLICT (id) DO NOTHING;

-- Public: Lloydminster Public School Division (2942 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '32a2c104-cb9d-5fdc-9266-7d35e1c28f95',
  'Lloydminster Public School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 2942. Code: 3170'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Grande Prairie School Division (8897 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'The Grande Prairie School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 8897. Code: 3240'
) ON CONFLICT (id) DO NOTHING;

-- Public: The Fort McMurray School Division (8144 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'The Fort McMurray School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 8144. Code: 3260'
) ON CONFLICT (id) DO NOTHING;

-- Public: The St. Albert School Division (9823 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'The St. Albert School Division',
  'large',
  'free',
  'Alberta Public division. Enrolment: 9823. Code: 7020'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Red Deer Catholic Separate School Division (10637 students, metro)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'The Red Deer Catholic Separate School Division',
  'metro',
  'free',
  'Alberta Separate division. Enrolment: 10637. Code: 0019'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The St. Thomas Aquinas Roman Catholic Separate School Division (4908 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '9857544b-ba36-55a9-abd5-d23a840771d3',
  'The St. Thomas Aquinas Roman Catholic Separate School Division',
  'large',
  'free',
  'Alberta Separate division. Enrolment: 4908. Code: 0020'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Holy Family Catholic Separate School Division (1867 students, medium)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '8c0c8c45-4448-53fa-9a4d-bbb06d80990d',
  'The Holy Family Catholic Separate School Division',
  'medium',
  'free',
  'Alberta Separate division. Enrolment: 1867. Code: 0021'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Elk Island Catholic Separate School Division (9229 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'The Elk Island Catholic Separate School Division',
  'large',
  'free',
  'Alberta Separate division. Enrolment: 9229. Code: 0046'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Living Waters Catholic Separate School Division (1783 students, medium)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '0d8f9ea1-7b1c-5304-9196-94a9af1600d6',
  'The Living Waters Catholic Separate School Division',
  'medium',
  'free',
  'Alberta Separate division. Enrolment: 1783. Code: 0047'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Evergreen Catholic Separate School Division (4255 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '40cdd9e1-3f9a-55d2-99fa-004cf411ddf3',
  'The Evergreen Catholic Separate School Division',
  'large',
  'free',
  'Alberta Separate division. Enrolment: 4255. Code: 0048'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Edmonton Catholic Separate School Division (50013 students, metro)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'The Edmonton Catholic Separate School Division',
  'metro',
  'free',
  'Alberta Separate division. Enrolment: 50013. Code: 0110'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Calgary Roman Catholic Separate School Division (63410 students, metro)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'The Calgary Roman Catholic Separate School Division',
  'metro',
  'free',
  'Alberta Separate division. Enrolment: 63410. Code: 4010'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Greater St. Albert Roman Catholic Separate School Division (5735 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'The Greater St. Albert Roman Catholic Separate School Division',
  'large',
  'free',
  'Alberta Separate division. Enrolment: 5735. Code: 4077'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Lakeland Roman Catholic Separate School Division (2708 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '43bee489-ff3a-5d6f-a7e7-4f03cd8455c0',
  'The Lakeland Roman Catholic Separate School Division',
  'large',
  'free',
  'Alberta Separate division. Enrolment: 2708. Code: 4105'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Grande Prairie Roman Catholic Separate School Division (5412 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'The Grande Prairie Roman Catholic Separate School Division',
  'large',
  'free',
  'Alberta Separate division. Enrolment: 5412. Code: 4130'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Fort McMurray Roman Catholic Separate School Division (7015 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'The Fort McMurray Roman Catholic Separate School Division',
  'large',
  'free',
  'Alberta Separate division. Enrolment: 7015. Code: 4160'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Christ the Redeemer Catholic Separate School Division (10389 students, metro)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'The Christ the Redeemer Catholic Separate School Division',
  'metro',
  'free',
  'Alberta Separate division. Enrolment: 10389. Code: 4208'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The East Central Alberta Catholic Separate School Division (2644 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '605d1dfd-ed06-5b4c-8472-1340e9ca561b',
  'The East Central Alberta Catholic Separate School Division',
  'large',
  'free',
  'Alberta Separate division. Enrolment: 2644. Code: 4330'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Holy Spirit Roman Catholic Separate School Division (5577 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'The Holy Spirit Roman Catholic Separate School Division',
  'large',
  'free',
  'Alberta Separate division. Enrolment: 5577. Code: 4481'
) ON CONFLICT (id) DO NOTHING;

-- Separate: The Medicine Hat Roman Catholic Separate School Division (2963 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'b8291d77-a15a-5663-8b1e-307b690c1c64',
  'The Medicine Hat Roman Catholic Separate School Division',
  'large',
  'free',
  'Alberta Separate division. Enrolment: 2963. Code: 4501'
) ON CONFLICT (id) DO NOTHING;

-- Separate: Lloydminster Roman Catholic Separate School Division (2763 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '5ade05e1-db42-555a-b0b6-4e7a238b0590',
  'Lloydminster Roman Catholic Separate School Division',
  'large',
  'free',
  'Alberta Separate division. Enrolment: 2763. Code: 4870'
) ON CONFLICT (id) DO NOTHING;

-- Francophone: The Southern Francophone Education Region (3990 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'The Southern Francophone Education Region',
  'large',
  'free',
  'Alberta Francophone division. Enrolment: 3990. Code: 0284'
) ON CONFLICT (id) DO NOTHING;

-- Francophone: The Greater North Central Francophone Education Region (4571 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'The Greater North Central Francophone Education Region',
  'large',
  'free',
  'Alberta Francophone division. Enrolment: 4571. Code: 8040'
) ON CONFLICT (id) DO NOTHING;

-- Francophone: The Northwest Francophone Education Region (475 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'ed9a2e7b-8278-515f-a881-f208c244c877',
  'The Northwest Francophone Education Region',
  'small',
  'free',
  'Alberta Francophone division. Enrolment: 475. Code: 8050'
) ON CONFLICT (id) DO NOTHING;

-- Francophone: The East Central Francophone Education Region (801 students, medium)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '6a0f7c7c-5efe-5d64-bbdf-e4195e5e75da',
  'The East Central Francophone Education Region',
  'medium',
  'free',
  'Alberta Francophone division. Enrolment: 801. Code: 8060'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Foundations for the Future Charter Academy Charter School Society (4161 students, large)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'c930a895-4a88-5847-be85-55e3c05ab921',
  'Foundations for the Future Charter Academy Charter School Society',
  'large',
  'free',
  'Alberta Charter division. Enrolment: 4161. Code: 0009'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Suzuki Charter School Society (420 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '49f6cf58-bfed-52ce-aeca-06699b353b30',
  'Suzuki Charter School Society',
  'small',
  'free',
  'Alberta Charter division. Enrolment: 420. Code: 0012'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Connect Charter School Society (624 students, medium)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'd5e38c23-0aae-5c47-87f3-55da298dfc0b',
  'Connect Charter School Society',
  'medium',
  'free',
  'Alberta Charter division. Enrolment: 624. Code: 0045'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Westmount Charter School Society (1316 students, medium)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '28c8a17a-cc76-517f-b0aa-6e402ac0062d',
  'Westmount Charter School Society',
  'medium',
  'free',
  'Alberta Charter division. Enrolment: 1316. Code: 0109'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Calgary Arts Academy Society (643 students, medium)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '87976353-51e3-5fa3-aafd-378d9bf5448c',
  'Calgary Arts Academy Society',
  'medium',
  'free',
  'Alberta Charter division. Enrolment: 643. Code: 0151'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Calgary Girls' School Society (516 students, medium)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '1900c524-90b4-59e5-811f-808ea632a1a1',
  'Calgary Girls'' School Society',
  'medium',
  'free',
  'Alberta Charter division. Enrolment: 516. Code: 0152'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Valhalla School Foundation (71 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '841aaeaf-7515-5aa8-8f1c-ea2d6ff2b753',
  'Valhalla School Foundation',
  'small',
  'free',
  'Alberta Charter division. Enrolment: 71. Code: 0224'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Footprints for Learning Society (499 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '6cf8a729-8aaa-530e-bf39-aceaaf1907d2',
  'Footprints for Learning Society',
  'small',
  'free',
  'Alberta Charter division. Enrolment: 499. Code: 0257'
) ON CONFLICT (id) DO NOTHING;

-- Charter: New Humble Community School Association (179 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'bb0d97c8-67ef-5a96-b0a3-71fbc613cb70',
  'New Humble Community School Association',
  'small',
  'free',
  'Alberta Charter division. Enrolment: 179. Code: 0369'
) ON CONFLICT (id) DO NOTHING;

-- Charter: STEM Innovation Academy Society (1154 students, medium)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '18c823d3-74f2-51ef-98ef-bdd53879afb3',
  'STEM Innovation Academy Society',
  'medium',
  'free',
  'Alberta Charter division. Enrolment: 1154. Code: 0370'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Alberta Classical Academy Ltd. (1284 students, medium)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'cfd03923-2bbb-56a8-8f30-e7ffe8be1598',
  'Alberta Classical Academy Ltd.',
  'medium',
  'free',
  'Alberta Charter division. Enrolment: 1284. Code: 0395'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Holden Rural Academy Society (123 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'a74d618b-4fc5-5cf1-a6da-ca539f881fa4',
  'Holden Rural Academy Society',
  'small',
  'free',
  'Alberta Charter division. Enrolment: 123. Code: 0399'
) ON CONFLICT (id) DO NOTHING;

-- Charter: STEM Collegiate Canada Society (360 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'd44f0646-9a6b-5b10-988b-8512283bb71a',
  'STEM Collegiate Canada Society',
  'small',
  'free',
  'Alberta Charter division. Enrolment: 360. Code: 0400'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Thrive Charter School Society (168 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '5fa6e2b7-9e12-57ef-b6d0-137cf0a931cf',
  'Thrive Charter School Society',
  'small',
  'free',
  'Alberta Charter division. Enrolment: 168. Code: 2473'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Fusion Education Association (92 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '441e76d5-2087-5b5d-80f4-dbacf887e603',
  'Fusion Education Association',
  'small',
  'free',
  'Alberta Charter division. Enrolment: 92. Code: 2485'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Gwynne Valley Rural Education Association (104 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'bdd3f6b1-9d51-558b-9db4-4499470aafb7',
  'Gwynne Valley Rural Education Association',
  'small',
  'free',
  'Alberta Charter division. Enrolment: 104. Code: 2487'
) ON CONFLICT (id) DO NOTHING;

-- Charter: The WISE Charter Society (186 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '0f638426-1485-590f-b5a5-332436ac01c7',
  'The WISE Charter Society',
  'small',
  'free',
  'Alberta Charter division. Enrolment: 186. Code: 2638'
) ON CONFLICT (id) DO NOTHING;

-- Charter: New Horizons Charter School Society (441 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '74383c55-679c-5994-b482-db8e499f7451',
  'New Horizons Charter School Society',
  'small',
  'free',
  'Alberta Charter division. Enrolment: 441. Code: 6015'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Boyle Street Education Centre (173 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '1791cb72-63ac-512e-aa59-be8cc9eee995',
  'Boyle Street Education Centre',
  'small',
  'free',
  'Alberta Charter division. Enrolment: 173. Code: 6017'
) ON CONFLICT (id) DO NOTHING;

-- Charter: CAPE - Centre for Academic and Personal Excellence Institute (292 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '668615e1-fe07-5193-ac06-80b43fa7a916',
  'CAPE - Centre for Academic and Personal Excellence Institute',
  'small',
  'free',
  'Alberta Charter division. Enrolment: 292. Code: 6019'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Aurora School Ltd. (1211 students, medium)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '06cc9841-255a-5648-9ce9-50df8db90dd9',
  'Aurora School Ltd.',
  'medium',
  'free',
  'Alberta Charter division. Enrolment: 1211. Code: 6020'
) ON CONFLICT (id) DO NOTHING;

-- Charter: Almadina School Society (1391 students, medium)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '5786e633-0455-5705-a127-49ade09a7bba',
  'Almadina School Society',
  'medium',
  'free',
  'Alberta Charter division. Enrolment: 1391. Code: 6021'
) ON CONFLICT (id) DO NOTHING;

-- Provincial: Kayas Cultural College (36 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '77433095-757a-536e-aa53-80c31a603282',
  'Kayas Cultural College',
  'small',
  'free',
  'Alberta Provincial division. Enrolment: 36. Code: 0079'
) ON CONFLICT (id) DO NOTHING;

-- Provincial: NorQuest College (516 students, medium)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '1f71e506-50e9-5c48-9bb3-6bbf5fac7246',
  'NorQuest College',
  'medium',
  'free',
  'Alberta Provincial division. Enrolment: 516. Code: 9216'
) ON CONFLICT (id) DO NOTHING;

-- Provincial: Bow Valley College (322 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '5cf05f93-9ab6-59e4-9225-71bd8bfc4bf7',
  'Bow Valley College',
  'small',
  'free',
  'Alberta Provincial division. Enrolment: 322. Code: 9217'
) ON CONFLICT (id) DO NOTHING;

-- Provincial: Portage College (202 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  '7297e54a-4de6-5c3c-9906-abfd6e1370c4',
  'Portage College',
  'small',
  'free',
  'Alberta Provincial division. Enrolment: 202. Code: 9239'
) ON CONFLICT (id) DO NOTHING;

-- Provincial: Northern Lakes College (19 students, small)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'b5cb76fe-398e-50b9-a3ff-b7bcdd186cc3',
  'Northern Lakes College',
  'small',
  'free',
  'Alberta Provincial division. Enrolment: 19. Code: 9240'
) ON CONFLICT (id) DO NOTHING;

-- Synthetic division for all private/independent schools (316 schools)
INSERT INTO divisions (id, name, enrolment_band, tier, notes)
VALUES (
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'Alberta Independent Schools',
  'metro',
  'free',
  'Synthetic division grouping 316 private/independent schools across Alberta'
) ON CONFLICT (id) DO NOTHING;

-- ─── Schools ──────────────────────────────────────────────────────────

INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2a57b632-428f-554e-b146-84e60990302f',
  'Lone Pine Colony School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 0392'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fd23b6d3-d06b-5dcd-b761-97b7aa69d2f8',
  'Silver Spring Colony School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 2033'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c2a4bf8d-a738-5f25-9c1a-399c068bc6f3',
  'Whitesand Colony School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 2153'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '40241747-62ef-5dfa-b617-2d6f285fdf48',
  'Big Valley School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4601'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1c989ea0-a676-571d-ae9e-18cfe704ea9c',
  'Botha School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4602'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '58dfdb1d-de32-514a-a9cf-526cd90b2ab8',
  'Byemoor School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4603'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b0c6e064-76e7-5e23-8b52-b150fa51cff1',
  'Donalda School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4604'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bcad2e70-01a1-57a1-a626-786d0c68ebb2',
  'Erskine School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4606'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fd6698ae-1479-58f0-be23-843c15100b64',
  'Star Ridge Colony School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4609'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '42055b9d-b592-52e7-bbee-12332c30b832',
  'Erskine Colony School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4610'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '94bdf578-a3fc-5581-ab43-25db442db17f',
  'Donalda Colony School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4611'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b03b2151-3813-52c8-a0d5-6b733bc887f8',
  'Byemoor Colony School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4612'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c71a46f0-8a85-5ffc-95e9-bdbd0fefadca',
  'Gadsby Colony School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4613'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2dbcb636-953a-5eaa-85ea-32431ed7fe30',
  'Stettler Outreach School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4616'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9cb5a50e-f5be-5db7-b8d9-e705dc00aac1',
  'William E Hay Composite High School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4644'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '15a6962c-9b3e-52b0-9445-9e2481cfa227',
  'Stettler Elementary School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4647'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '574b9f35-6a9d-5c84-a3a2-5625d23012e7',
  'Brownfield Community School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4821'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e1356d83-65f2-5450-b9f2-0134cf76b520',
  'Gus Wetter School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4822'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8770a949-72be-5d05-a847-9c4edc70faaf',
  'Coronation School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4824'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e9a90531-35de-5b19-81e6-75dea487a90c',
  'Lanes Lake Colony School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4826'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6374e9be-c450-58e2-99df-65da9e284c8f',
  'Suncrest Colony School',
  '40466c35-f546-5aa6-a436-d5b06412dfa1',
  'free',
  'Alberta Public school. Authority: The Clearview School Division. Code: 4827'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '40aeb22e-254c-565b-b448-1d886896c0ac',
  'Rainbow Colony School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 0385'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1bf3c15d-abec-563a-a9af-2f7a4f48ca78',
  'École Fox Run School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 0524'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1877f7f6-0af1-51d6-9b14-6ee3b997728f',
  'École Innisfail Middle School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 1133'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dbf72684-8914-5875-8240-6a7e7841c9db',
  'Carstairs Elementary School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 1469'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c7942b37-0290-5622-9afe-6ef4a19b6510',
  'Penhold Crossing Secondary School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 1771'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a9b57bdd-2969-55b0-bc82-c9789749404a',
  'Beacon Hill Elementary School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 1980'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '371116c2-0000-5ac9-a20a-fdcc96f18d06',
  'May City Hutterite Colony School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 2358'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '29700307-9ee7-5d73-a486-701f5b9faa21',
  'Bowden (Grandview) School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4402'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a0d55647-3663-57dc-a3f7-bae965288551',
  'Delburne Centralized School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4403'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3bb47a93-c996-5ef1-8429-fc7ada346892',
  'Elnora School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4404'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '212aa65f-0f7f-5967-b196-036eb199c484',
  'Innisfail High School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4405'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a8484c5b-934d-5c51-9434-b569d7d5c6cf',
  'École John Wilson Elementary School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4406'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ddf34b8e-093f-5e9e-846f-5416843b8600',
  'Penhold Elementary School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4407'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '87dade8e-f002-5751-a749-5ee119901ebd',
  'Pine Hill Colony School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4408'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '40e0899d-5a55-5eb5-960b-6a70e93da92a',
  'Spruce View School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4410'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8dda39cd-267a-5877-b453-385b1303f296',
  'École H.J. Cody High School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4411'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a3f41970-74d0-5eb4-8f27-5dc4bdf78090',
  'C. P. Blakely Elementary School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4412'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '850e63d8-4952-5e28-8d91-d3d772020b89',
  'Poplar Ridge School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4413'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5713279b-d614-5886-a7ca-60d16556eca5',
  'Jessie Duncan Elementary School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4414'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'def4bf1c-be80-5cf6-af83-30d1d1b48b94',
  'École Steffie Woima Elementary School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4415'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '254117df-df8e-5bff-90ec-27f7d0d1d038',
  'Penhold Career High School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4416'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '39f5baa1-5a51-5ea9-8c99-84eb0a7316f0',
  'Sylvan Lake Career High School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4417'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c7dc258f-047f-5a7f-988a-78f9b8b1d037',
  'Didsbury Career High School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4419'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c3ae1773-6ac6-5704-aa1d-e83763f5ba94',
  'Sundre Learning Centre',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4420'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '21c7a21a-dfbe-5dc6-8997-d416ec338c5c',
  'Innisfail Career High School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4421'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4579e427-046a-5091-aa2b-a6abf63e2c8a',
  'Off Campus Learning',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4423'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4f9a064c-f01c-566a-8182-36683e1a5163',
  'Olds Career High School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 4425'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9a59bac0-cfeb-53f8-af38-6ac7594283bc',
  'Hugh Sutherland School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5101'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e6fcf19d-9503-5d64-ba34-473402a3974a',
  'Cremona School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5103'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '197de3cf-a6f9-5ea2-a304-a03cf1f18f2b',
  'Didsbury High School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5105'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '18b2db60-8f36-5c88-91bf-57467e74d630',
  'Ross Ford Elementary School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5106'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '964c6a87-933d-584c-9f34-cfa71cdc99cf',
  'Westglen School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5107'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b2c8b472-3c59-57d8-ae4e-51c35958d619',
  'Sundre High School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5112'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5b944969-28b4-5f71-aa69-f7201ae67ff4',
  'École Olds High School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5115'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '37a9b9bd-8661-5d5b-bbcb-9eef2b346d97',
  'École Olds Elementary School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5116'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9a62cb59-4f00-5804-bba9-4405b9a64fee',
  'École Deer Meadow School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5117'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7d48431c-263d-58e7-9c86-ce7c30f417c6',
  'Reed Ranch School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5118'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e6a08edb-3ef1-5161-a493-55aada2d8cc5',
  'River Valley School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5120'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c8629eb1-62b1-56b0-9bba-c3058b450c7d',
  'Neudorf Colony School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5121'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '43af728c-00ac-5c89-8662-507938aad9e7',
  'Horizon Alternate Program',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5191'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '03a618d5-f6f1-57a8-bdca-3b67482c5ef9',
  'Olds Koinonia Christian School',
  '6e955e80-602d-5443-afc5-bea601fc5235',
  'free',
  'Alberta Public school. Authority: The Chinook''s Edge School Division. Code: 5193'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3f682e06-8749-5938-9462-bfb9e6bc832f',
  'West Country Outreach School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 0488'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7a4bc689-7c2e-5078-81c1-2d3e65ea77ee',
  'Bentley Colony School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 0586'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2cbaec61-f813-52f9-b073-5fe902845363',
  'Iron Ridge Elementary Campus',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 1464'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8c967e61-1cc1-59ac-a65b-8042053ed8e8',
  'Iron Ridge Intermediate Campus',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 2061'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a42b9df8-f868-5b05-a670-a5aa3ca90e38',
  'Iron Ridge Secondary Campus',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 2563'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '75abef8b-0f29-5d0b-994a-654e7e1495ad',
  'Bluffton School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4201'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3384b26e-3ddb-5fa3-bc50-340c04ad3d30',
  'Crestomere School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4202'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8897697d-0f00-5163-a24b-4163e9a4ef9a',
  'The Brick Learning Centre',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4203'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e58d9d09-7ed2-5d69-a631-92c8ee8d0555',
  'Mecca Glen School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4204'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '78a2718a-8ed4-5503-9e3a-b96defa11d40',
  'Ponoka Secondary Campus',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4205'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '996b4ad4-7bf5-56fb-b807-8b30d905a075',
  'Ponoka Elementary School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4207'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1e4ba3ba-8319-5abe-9cca-b67e88484900',
  'Rimbey Junior Senior High School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4209'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0cedc91b-6dc1-500b-ac98-0570209817b8',
  'Rimbey Elementary School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4210'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c12710dc-0682-5ef4-a86f-a522431ef0ea',
  'Ferrybank Colony School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4213'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e50a144e-75bc-5f4b-a284-fd1c9d3bfca6',
  'Wolf Creek Education Centre',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4299'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6a8a5402-5050-5212-bb44-52b6e36e82ba',
  'Alix (Mirror and Alix Central)',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4301'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b54c95cc-92c0-52e6-88ce-3951e03b03e8',
  'Bentley School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4302'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '29516286-8c81-5b22-9de2-364c4f519be7',
  'Iron Ridge Junior Campus',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4304'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '798836cf-cc72-5b75-b5dc-0b858b745e9b',
  'Clive School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4305'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ec68d90a-ddd7-5822-9146-bbccb31249b5',
  'Eckville Junior Senior High School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4306'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e53e341d-7893-5547-bedf-61e1213ba664',
  'Ecole Secondaire Lacombe Composite High School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4307'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1e9cff38-eb4a-56f7-802a-a65572c841c6',
  'Ecole Lacombe Junior High School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4308'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '35067f52-7e7f-5af3-8a86-fa74a9aa7b8c',
  'Ecole James S. McCormick School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4309'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b85d998f-0fd7-55d3-87b4-110608c11c71',
  'Terrace Ridge School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4310'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6cd4ac17-9bcf-54ee-a5b7-c007ee99ae5d',
  'Eckville Elementary School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4315'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'da277144-b95a-5b1c-9ff0-05c4e0af9d63',
  'Pleasant Valley Colony School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4316'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1d28e00e-69e2-5e0c-87f3-cfe103bb2f30',
  'Leedale Hutterite Colony',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4317'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '30e3e086-778f-59b3-bc74-eb53a1fa9739',
  'Ecole Lacombe Upper Elementary School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4319'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3d9afcdb-6b62-53f2-b267-d0e731a69d37',
  'Alix Colony School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4320'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b817e10e-e425-5e8b-9846-8cdb77696975',
  'Lacombe Outreach School',
  'df789aa3-6ff4-5874-9a46-e64e799d8e1c',
  'free',
  'Alberta Public school. Authority: The Wolf Creek School Division. Code: 4322'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9eb12b9e-9833-58cf-941f-e018683b7f59',
  'Spring Valley Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 0011'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6c62a1c5-04b7-5d9a-86a1-35fe7fca4ee9',
  'Westwind Alternate School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 0576'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ea30d254-d6ab-5a0d-89c3-45a4ff84cff9',
  'Blue Ridge Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 0994'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '058bf368-d60e-5449-8304-3f42cd471b9d',
  'Raymond Alternate School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 2257'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '29f8e0d6-b2e7-54da-8206-fbe5c8d98779',
  'Cardston High School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6201'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '43383833-2e8f-50c2-b6b7-6b9c15a69355',
  'Cardston Junior High School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6203'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '72f620ad-c1d3-5456-b43b-69168a80a6b2',
  'Cardston Elementary School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6204'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1f69d5f6-fcc0-5b35-a0e7-51111570a7cd',
  'Spring Glen Elementary School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6207'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'aa899391-ac1e-5329-8986-0d76e1794927',
  'Magrath Junior Senior High School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6210'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '25ec0b2a-b3ef-578a-bd9f-8708078e5e98',
  'Magrath Elementary School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6211'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f5c7ee69-0145-57d0-893a-ca6a91e6772b',
  'Mountain View School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6212'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '16b88903-6f7f-5f2a-b921-0cd988eef133',
  'Big Bend Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6213'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '610c6b6c-fd89-5638-8c47-4e51e24c5793',
  'Crystal Spring Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6214'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd528f396-16c0-5f34-8345-92569a99e12f',
  'East Cardston Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6215'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '32a20fed-6f1f-5e1f-b31d-a34ed1cc3ab7',
  'Hutterville Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6216'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8ff3766c-e6e3-5b39-a0c7-2aeb33334199',
  'New Elm Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6217'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fa903295-6cd8-5c30-8d40-5e8fd2432bf2',
  'Old Elm Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6218'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '49d5db8e-07b6-5698-bb39-b4c06222cebd',
  'Riverside Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6219'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '24fad5c1-1c6d-5e40-b445-3cd01ccb3569',
  'Rockport Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6220'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c1075453-3e21-5101-947e-80ed4c3e2294',
  'Standoff Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6221'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ff98d89c-ece2-555a-9515-c6f62573c663',
  'West Raley Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6222'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ccb003ea-7313-5227-9e09-e8347ffa1517',
  'Spring Glen Junior High School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6223'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e8a69201-8496-5413-999f-ae1e0b2f452d',
  'Deerfield Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6225'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6f09b009-e35f-5411-8648-bfcee7192a5c',
  'Raymond High School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6506'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ebfa978e-0c6f-56b8-a32a-ae56f57fb3d5',
  'Raymond Junior High School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6507'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '390ccf97-f41e-5d86-8d8c-f2875a062160',
  'Raymond Elementary School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6508'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f46d58f2-2dfa-5323-bbe8-d3ec23804c59',
  'Miami Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6514'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cf6c8b5b-834c-51f2-86a1-310de89501ff',
  'Milford Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6515'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '534bfa22-00d8-5094-800b-d6f229aa01be',
  'New Rockport Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6516'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '19e6764f-981e-5621-94c2-9e029b9f6927',
  'O K Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6517'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '312a3d34-1a67-531f-a691-a1ef699f9d53',
  'Wolf Creek Colony School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6519'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1d5ff4c6-1b32-5557-b92f-0482baa3be6b',
  'Stirling School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6535'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a1bd0dbe-d167-5680-9025-9718846cf187',
  'East Raymond School',
  'e70f698e-498a-5b96-bcd2-2adc9e2586d7',
  'free',
  'Alberta Public school. Authority: The Westwind School Division. Code: 6536'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '98ec2227-111e-52a2-891e-23b8e5d0a2a5',
  'Peace Academy of Virtual Education',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 0319'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '51538197-110b-5152-b83a-5fd25aa4c3ce',
  'Peace Wapiti Academy',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 0590'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '62caa3d0-9c32-5239-9a97-990d9f5d07c3',
  'Codesa Hutterite Colony School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 0591'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6e6c8fd2-2396-549f-b882-14be6c0150c4',
  'Horizon Group Care',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1055'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5cfae738-2d78-50fc-8b9f-c352f5d72567',
  'Beaverlodge Regional High School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1101'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e7e3e819-7ca2-5270-902b-89791c89db68',
  'Beaverlodge Elementary School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1102'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '73dabfbb-77ff-5d7e-8989-80f2c0e24f9b',
  'Bezanson School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1103'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0156481d-0579-5221-a7f1-929ec2a742b8',
  'Elmworth School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1104'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3707d162-48d0-509e-a133-ed6ae829fe97',
  'Harry Balfour School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1105'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '27073c25-172d-560f-b316-7f345e6efb49',
  'La Glace School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1107'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b7536e72-8ff5-5bdf-b8d0-3199bc48cc29',
  'Sexsmith Secondary School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1108'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '723fec24-65a7-5e0d-9596-3982b76bb5d8',
  'Teepee Creek School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1109'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '69d6c691-f28a-5bbb-a99d-bc98fc35413e',
  'Helen E. Taylor School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1111'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '764a7687-b26a-589c-bcb3-914b31964671',
  'Robert W. Zahara Public School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1112'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '24ef291f-1d57-5fa4-8c60-2033731b585b',
  'Wembley Elementary School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1113'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '74a2adbd-33e4-50e1-9680-e3446c1d3557',
  'Hythe Regional School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1115'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '13e6abdd-3f56-5345-9536-83eff96a69d3',
  'Grandview Colony School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1116'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6d1a2ec0-5ff4-5d8a-b313-b09e1c711f9d',
  'Penson School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1135'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '709deff1-eb29-5f68-b2bd-605dcebaa31d',
  'Ridgevalley School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1203'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'eda3d9ca-2ac3-5a07-bc85-19bb024849c3',
  'Crooked Creek Colony School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1209'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd9cac374-bdb2-5d45-b847-f3701bb5b0c6',
  'Shady Lane Colony School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1245'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8e9cbc10-01a8-5730-ad17-5999364e4a91',
  'Bonanza School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1302'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4bbdb063-513b-5f94-be19-59e6fe902e53',
  'Eaglesham School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1303'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd90c7280-c27d-5886-81ef-f537055a83f2',
  'Rycroft School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1304'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a8f379fa-b0c8-58d0-9f29-092e93806e73',
  'Savanna School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1305'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3b8b8e9c-4b30-5283-9750-4940d859c4fe',
  'Spirit River Regional Academy',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1306'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5bbadc8b-f38a-5bba-891b-993954e0e975',
  'Birch Hills Hutterite School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1311'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8fafa799-64f8-5b6b-aecc-264aec2644d8',
  'Clairmont Community School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1424'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c941c1bf-1446-5b23-ae29-baec55159b6e',
  'Birch Meadows Colony School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1468'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bba8ddaa-1848-505d-8329-e3697023e5c3',
  'Doe River Colony School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 1632'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5e935a16-3ecc-5af1-ae5c-1226a95ad925',
  'Whispering Ridge Community School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 2078'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '75df7dfa-9534-5040-8847-f6a33035b64e',
  'Silver Valley Colony School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 2126'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6575fb86-3bd3-590c-b5f4-3ce3a61d841b',
  'Peace Wapiti Enterprise Centre',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 2239'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '304e3324-9149-507f-9553-a8617783e07f',
  'Bay Tree Colony School',
  '5817dde7-ba65-51f3-8c95-61f2c958dce5',
  'free',
  'Alberta Public school. Authority: The Peace Wapiti School Division. Code: 2256'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3b79bd3e-2141-5d61-9782-1a63ab64b17a',
  'Silver Sage Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 0393'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2ee04a7f-8e54-5d96-b05c-e7c118992166',
  'Coulee Collegiate',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 1021'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'be6237ba-d7eb-550e-9fde-873cddb8f380',
  'Redcliff Mennonite Alternative Program',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 1785'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a8c35cef-1c48-59ad-bbe9-dd09f255f3c1',
  'Hutterian Brethren Church School of Murray Lake',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 2131'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '65bc689a-eca1-527f-810a-d691a9835eef',
  'Meridian Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 2183'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a210c530-ac68-5cdb-b0ae-ef2fc8ebf2e1',
  'South Alberta High School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 2200'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '73fec970-1294-569b-b30b-a8f8497066aa',
  'Prairie Mennonite Alternative School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 2263'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f8950195-0e90-551a-93e9-464525fe9d06',
  'Baker Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 2264'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8c1c8898-3ed8-5f13-bc8e-7e731fe64b8d',
  'Warren Peers School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 5901'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ffd53615-0a2b-53a5-88dc-6225c5177270',
  'Shamrock Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 5902'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '553ef08c-ef6a-5272-b4e8-2f522b10f7bf',
  'Eagle Butte High School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 5905'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '41a64e11-8df9-51a1-a273-27f0196e5914',
  'New Brigden School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 5907'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b7187fb1-284f-57c1-ade8-69d21afebd6e',
  'South Central High School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 5910'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '56932b79-8e5f-5058-b642-fd7a520dea37',
  'Oyen Public School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 5911'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b42ffda5-5249-5f4b-93ed-1fc44aec50be',
  'Acadia Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 5913'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd2fc7a7d-48a2-5cdf-a813-1e0913f7e872',
  'Prairie View Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 5914'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0bd493a2-5ec9-5d31-936c-9f38e53382e9',
  'Irvine School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6803'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6b02a5ec-41fa-5767-9df0-772f6a5408a9',
  'Jenner School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6804'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '780685ad-c08a-5b56-89c1-40c4fd630cef',
  'Schuler School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6807'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '12cdfbd9-6066-5749-8f26-6ddf807318a1',
  'Seven Persons School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6808'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6b899944-3bc7-56e6-8d92-03fab467bf16',
  'Hutterian Brethren Church School of Elkwater',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6809'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd63e0044-116d-5081-a1b3-b0a4718a49e2',
  'Jenner Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6810'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4a006c6b-bf7a-5b60-aa80-a240d1007410',
  'Roseglen Hutterian Church School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6812'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '61e1d29c-2350-55ae-add3-44182a8bc2ae',
  'Parkside School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6835'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e1493add-c5bd-50f7-b172-e2998f518dc2',
  'Isabel F Cox School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6836'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '49f584cc-ec6a-5c62-bdf1-3c2850d5944a',
  'Margaret Wooding School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6837'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a3c336d3-9606-5496-b1f7-bb9f92964dd5',
  'Ralston School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6891'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'be7195ac-1f20-53e0-aba6-be1881aa216b',
  'Senator Gershaw School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6902'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e9afb09f-78f7-5974-b6ba-4e941d4d97b0',
  'Bow Island Elementary School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6903'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a9e60cdc-ff91-5722-ae4a-6765a2b11cd4',
  'Burdett School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6904'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c51c65f3-ba23-5037-9ca5-c65771e8f74c',
  'Foremost School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6907'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6ba9e02a-d0a7-5f18-9c1e-64fc665fa91c',
  'Rosedale Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6909'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9cfd6da2-9673-55f1-bd5c-bc461c67d8d7',
  'Winnifred Hutterite Colony',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6910'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1054a922-1611-5142-ac48-b510b2511be7',
  'Ponderosa Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6911'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'befde46f-90f2-5afa-b23c-b1b134141f5f',
  'Plainview Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6912'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b9866ce7-1733-5f85-9bfc-438ee65b8915',
  'Kingslake Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6913'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '05277e4f-c332-584a-9b3d-51506f784c48',
  'Sunrise Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6915'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0d2aabc8-0752-5b27-b643-915c562acf93',
  'Mayfield Hutterite Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6916'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'aaeded1b-0985-5020-ae59-d5bc5a69954a',
  'Starbrite Hutterite Colony School',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6918'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '70c1074f-f6fa-5b40-8e8d-c35a783d7e82',
  'Prairie Rose Regional Division Home Education',
  '208c3cc2-3245-561d-a7ff-477c2ff684b3',
  'free',
  'Alberta Public school. Authority: The Prairie Rose School Division. Code: 6919'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8ea64e2b-f89d-5ce9-b20c-4b5b1a3b3821',
  'Prairiehome Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 0009'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ceafdeee-53cb-5555-adc1-d1f100147b24',
  'Bluegrass Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 1033'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '22e4c595-f369-533c-9f72-00a990619e91',
  'Armada Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 1100'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'abd30d23-813b-5571-b809-5d7735becc89',
  'Delco Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 1114'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ac1598d5-bd03-53f2-9cca-6ef61dca0365',
  'Horizon MAP School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 1129'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f0a7fd67-779d-57d1-9508-c1351af35373',
  'Kingsland Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 1377'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2751927b-94d2-59ae-8051-61a8edd052f9',
  'Evergreen Colony',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 1422'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e69fb3d0-c69d-5dcf-a273-fe2aa0d56879',
  'Arden T. Litt Centre for Learning',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 1473'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bb168e30-4c81-5328-8c2a-20774683567b',
  'Copperfield Farms Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 1479'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f6371fa6-0dd2-5485-bf78-f8a43b5fc8cd',
  'Goldspring Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 1997'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd301f943-a1c3-5efd-897b-cdc956252a67',
  'Taber Christian High School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 2333'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '95439ff4-f45d-5200-aaca-e3867dfd75f5',
  'Lomond Community School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 5405'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4a3343b3-bd2d-5f3a-85c0-82570e80524a',
  'Lomond Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 5415'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '24ac5c1f-45bd-5d78-8fda-15a30f6d99fb',
  'Cameron Farms School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6493'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5260c148-d62f-52e0-94fd-093a3d102371',
  'Erle Rivers High School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6503'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8a82c6c2-a5a7-50ef-98c0-e1a590275185',
  'Milk River Elementary School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6504'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fa078cfa-a9e2-55b5-9f55-16622b5343b5',
  'Warner School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6509'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '66a0d270-1657-5a72-a91f-6c29396d5aa4',
  'Elmspring Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6513'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '286fa48c-bbfb-5c69-94fe-cf160b3252e1',
  'Sunnysite Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6518'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '24de3802-de9a-54ab-9cfb-74607d8f9530',
  'River Road Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6520'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ac456e74-d758-503d-8425-06b8fd6087a3',
  'Fairlane Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6521'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '00fe7831-60ba-5856-a7e7-07384dfe29fe',
  'Miltow Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6522'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '14fc06c1-dfc3-5d48-a221-52a11ab4a84e',
  'ACE Place Learning Centre',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6523'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd14ee640-82a0-51a8-973c-7f90ef7312e7',
  'Barnwell School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6601'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bf595060-e3e1-5f76-94b2-dfb3e28746d4',
  'Chamberlain School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6602'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f21e66fd-fa77-5014-9c6b-a4c4f150d9ce',
  'Enchant School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6603'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '02934a5c-257d-5aa1-ba71-c7b3cf7709bc',
  'Hays School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6604'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8e3c9248-90b0-5804-96e4-885cd441a9f6',
  'W. R. Myers High School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6606'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '45d2a484-db45-53ce-8d2f-daee2105939d',
  'Taber Central School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6607'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6cbb59d8-f378-5ea6-8325-c70f3cec41b0',
  'Dr. Hamman School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6608'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bb4be1aa-d06e-5851-a810-cb2c01973845',
  'L.T. Westlake School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6609'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '04539efd-8d83-5c4f-a74b-cf337156825c',
  'Vauxhall Junior Senior High School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6611'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9c582838-0e36-5080-8bda-a7061400d93b',
  'Vauxhall Elementary School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6612'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6ee22f20-a02f-5a0e-889b-1cc8a9128d20',
  'Midland Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6613'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b5b8fc72-965d-53b6-b751-167c95f70050',
  'D. A. Ferguson Middle School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6614'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5c56644d-ea7a-5ea7-afbd-9b7e2174c0aa',
  'Taber Christian School Alternative Program',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6616'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'adb1d0fd-0e1b-5a2a-9ccf-83d23b8ae87f',
  'Enchant Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6617'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5a94030d-cd0a-54d8-9d9d-1fe21ea8d801',
  'Oaklane Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6618'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0438409c-f6cf-52ef-8982-ffabbd449680',
  'Hillridge Colony School',
  '0d8caea4-2db3-5a69-ad1c-d39961dd35ea',
  'free',
  'Alberta Public school. Authority: The Horizon School Division. Code: 6619'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '899d0a91-7301-54e2-a27a-50a100680205',
  'Red Earth Creek School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 0339'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'af4710ee-5030-5029-9a48-c1648f227f6f',
  'Cleardale Colony School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1045'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '72ab5b7e-4687-516f-8b60-2a29adcdbdfd',
  'Breaking Point Colony School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1051'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8b4ba25b-cadf-5fbd-a8ad-37e2a0ca8837',
  'Peace Regional Outreach Campus',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1376'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dcb39632-8c83-596e-b8e7-b25417ada7e2',
  'Fairview High School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1402'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a0edd530-8225-5b74-85e5-ed609db7a84f',
  'E E Oliver Elementary School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1404'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '237ca749-8907-5a8a-8c6b-6ce9687718f3',
  'Hines Creek Composite School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1405'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '175d86d1-b52a-5317-b436-92e142892eda',
  'Worsley Central School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1407'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '116e293a-4d17-5d6e-b881-1509fee15a6a',
  'Lloyd Garrison School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1501'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7fe1343d-55bc-5ee7-b31c-1c808aa4cd9c',
  'Dixonville School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1504'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f7b5a207-c24e-5844-a4f5-cb8f9e21e3fb',
  'Grimshaw Public School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1505'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '531830e5-1789-5ec5-82ad-cf41c3f45c58',
  'Paul Rowe Junior Senior High School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1507'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '80d9d798-6d26-5a8c-976e-a9bd8827f354',
  'Manning Elementary School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1508'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '63049663-0c20-5da3-9da9-999d2a6068bf',
  'Nampa Public School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1510'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3e0b7c78-e3f6-5685-81b1-23d3916065a1',
  'Peace River High School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1511'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a32990b8-c389-599f-828f-e858f9fe315d',
  'T A Norris Middle School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1512'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '41af214d-af4b-5f48-a309-8d9c53831982',
  'Springfield Elementary School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1514'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '14be7fc9-d675-5eae-ab10-f8eb5eae6164',
  'Fairview and Area Learning Store',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1542'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1aec83b1-2808-50b7-882c-06819490e344',
  'Menno-Simons Community School',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1825'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a7bd1c20-2b61-5ed8-b5b8-405c33c3dfa7',
  'Bear Canyon Hutterite Colony',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 1985'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ebe929e6-2208-51e5-931d-c5a79a3c385f',
  'Peace Home Learning Connection',
  'f75f1c06-781f-5b25-81c8-f0749eea5773',
  'free',
  'Alberta Public school. Authority: The Peace River School Division. Code: 2337'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd1f66ceb-5cc9-5fa4-a5dc-7433001de269',
  'The Learning Connection - Grande Cache',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 0327'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9581f8b0-0161-5955-9435-0d633ecd49c9',
  'Mary Bergeron Elementary School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 1266'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a07a533c-69cb-58e7-bc75-e6c1e46ca2c3',
  'The Learning Connection - Evansburg',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 1731'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '92283e16-9aaa-50f3-9dbe-40d060b00c01',
  'Parkland Composite High School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2002'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3fab6e4a-ac6d-544c-8b31-14bae75f2695',
  'Ecole Pine Grove School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2004'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b238994d-8dbc-5140-950f-9e7ffa9088bb',
  'Grand Trunk High School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2008'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c76a5912-567d-5b9e-a7ae-328ed1d0100a',
  'Evansview School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2009'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a2896438-3474-5db0-9809-04c8b585c1dc',
  'Fulham School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2010'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b31df81a-5c67-5ff5-ba23-a96b3f53a76a',
  'Harry Collinge High School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2011'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cc657d07-e829-512f-808c-6dfddccb5213',
  'Crescent Valley School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2012'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a072b17b-f494-5988-a1db-9f80a37f0a41',
  'Ecole Mountain View School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2013'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4ebe736c-3d2e-5a03-9d86-78dfe262364e',
  'Niton Central School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2015'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bcd07c32-947b-5717-a00a-1ae12a82056b',
  'Wildwood School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2018'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '692f250b-f8bd-52ca-8e4e-946561deea69',
  'Westhaven Elementary School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2023'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3b0b58dd-3c92-5706-8a44-1087d7c5227b',
  'The Learning Connection - Edson',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2027'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0df9bb1f-a80d-5ca4-a1a2-589cc2e5a991',
  'The Learning Connection - Hinton',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2028'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'db26bc64-1241-57aa-923a-0f2facaf96ed',
  'Jasper Junior Senior High School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2035'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '313a2679-1478-5e66-99a8-2c06a9ad5f88',
  'Jasper Elementary School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2036'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5dfbdb52-bf04-5740-bc16-bd828e861d09',
  'Grande Cache Community High School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2042'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '14c56369-6a10-5ca0-9bf0-e2cbac748fe4',
  'Summitview School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2043'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '693a03dc-65bf-5254-b6d2-99f1fec9cd21',
  'Sheldon Coates Elementary School',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2044'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f984e20d-47c6-5e72-b17a-7f7758a00455',
  'The Learning Connection - Jasper',
  'b6ec6709-33fb-50cd-982b-2ea5859ef3e5',
  'free',
  'Alberta Public school. Authority: The Grande Yellowhead School Division. Code: 2163'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '492684a8-1ba2-5e68-b2c9-6b3583cc7eaf',
  'Morinville Public School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 1582'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8e80db53-a248-53da-b357-0cd66c3bd37d',
  'Four Winds Public School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2248'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f05ce86c-3e47-5d2c-9230-91c5b648ccaf',
  'Sturgeon Public Virtual Academy',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2353'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f394f4f4-7d82-56e0-8974-323284996c27',
  'Legal Public School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2451'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '54fa4dc5-71c7-596f-b06d-4622c68fcf3a',
  'Bon Accord Community School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2501'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '778d3761-a10d-53c0-b55b-57521a9b7238',
  'Camilla School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2502'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f55342b2-720d-5157-95fb-6d3eec30856c',
  'Gibbons School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2504'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4f00770f-3afd-5854-a7cf-afd2c4ce63f1',
  'Sturgeon Heights School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2506'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a1f5cc33-5b8e-563f-8f7c-313be7ffccc4',
  'Namao School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2507'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e7ccd764-83f2-5406-ade8-f61d8c49f129',
  'Morinville Colony School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2508'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e73d75a0-d857-5bc8-9956-831eef7ff1e4',
  'Oak Hill School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2509'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3dbf82a4-6f98-5fb7-96ad-cdf15901e2a2',
  'Sturgeon Composite High School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2510'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '03c33aa6-bce3-5821-ab34-496e492fecee',
  'Landing Trail School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2512'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7721c834-0028-5c4d-9271-b17c81a25c8b',
  'Ochre Park School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2513'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd9975690-29c1-5354-b681-dd2dc580ee7b',
  'Lilian Schick School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2514'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3e14d204-91e6-5125-bb64-8b5da1c06cb9',
  'Sturgeon Learning Centre',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2516'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ba46ed11-6d9b-5dbd-a7d4-93c811faccf2',
  'Redwater School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 2623'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4c136a1d-f915-54b7-b457-34629afd705f',
  'Guthrie School',
  '9e3d7327-adc3-5b0b-8429-1125c4331886',
  'free',
  'Alberta Public school. Authority: The Sturgeon School Division. Code: 3392'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2fc73ee5-eeee-510d-87b9-efe63992c3ce',
  'Prairie Land Outreach School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 0486'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b2d43904-4d4e-56c6-adf0-faf75e6ef79e',
  'Neu Muehl Colony School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 0580'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b07780df-ba66-5700-ba4a-a50694e07c8d',
  'Cloverleaf Colony',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 1421'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b5c6d8bf-47af-5ef6-ae1d-1b0b7901812f',
  'Prairie Land Online Academy',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 2373'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1475be4a-7dcb-50fa-aa5d-e2bf3067a5a0',
  'Al-Amal Academy',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 2374'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '32fdeaea-0176-5e12-9cc4-4d10ea8771ec',
  'Al-Amal Online Academy',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 2561'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6c00c17b-a475-5aff-ba57-6fc351faa1ec',
  'Wind River Colony School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 2627'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '91379ab6-8566-5db1-812e-6d0399d6200d',
  'East River Colony School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 2628'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '01d09314-3f17-5913-a5d4-864ea361d3f6',
  'Green Dome Islamic School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 2636'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '820c9451-886b-58f9-b5e4-902c48f1e30c',
  'Altario School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 4801'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7eca4406-98bc-560c-b1ee-b99a997057c3',
  'Consort School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 4802'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4446c22d-9340-5dc8-832c-08d6761cb75c',
  'Veteran School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 4803'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1cf04328-3933-5125-b959-2616964f01d5',
  'Veteran Colony School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 4804'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8edad976-f851-5184-b5af-27788b3dabb1',
  'Hope Christian School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 5491'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3e1b28ba-756b-5241-8317-56871bf18a3a',
  'Delia School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 5702'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1e012f62-3f94-58bc-aae0-bf89b8a2af8a',
  'Morrin School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 5705'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0dc075ad-1c86-5dcd-a345-c5248d81a18e',
  'Starland Colony School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 5709'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'becaeca8-e288-5d7f-a77f-d137c3e9809d',
  'Verdant Valley Colony',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 5710'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1365031f-19dd-5dc4-9b43-fdc91cc5472e',
  'Craigmyle Colony School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 5711'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8b8b42b4-4db0-5b15-93ca-8963085253c9',
  'Blue Sky Colony School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 5712'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '55601218-d57f-55c6-bdfb-1de0c1bee2ab',
  'Berry Creek Community School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 5802'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c8dd7bfd-78a1-5c3e-80ec-1a65cc7ff266',
  'Youngstown School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 5827'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '45423b22-b461-5d52-8992-a0a7d167d097',
  'Handhills Colony School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 5828'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9091979b-3726-54ea-a97c-27aa2527b0af',
  'Berry Creek Colony School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 5829'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '23e32474-09a2-5684-96ef-ab99775958a9',
  'J. C. Charyk Hanna School',
  'a1b3adde-377c-5dec-b273-05df2ba10b25',
  'free',
  'Alberta Public school. Authority: The Prairie Land School Division. Code: 5844'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1eaca8e5-3711-5e80-9e79-9247fe7c83d5',
  'Greenwood Colony School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 0430'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ec89b17a-9c5e-5f7f-925a-e7fc7686809c',
  'Livingstone Colony School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 0534'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6d3c9c09-fc57-58e4-b3ad-2cc519a98dd5',
  'MHHS Gateway School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 1076'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9c20012b-3f1e-5bfc-8595-e56e405d5fb6',
  'Walshe Crossroads Campus',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 1445'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f7ded552-6a4b-57e5-b212-8b5cd4200963',
  'Livingstone Range School Division Virtual School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 1996'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cda8361e-9c6c-5baa-a2e2-b49fe5aabe1f',
  'Jumbo Valley Hutterite Colony School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 2137'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd6fbf8e8-eb53-5b14-b429-9bfc7763f1d7',
  'Isabelle Sellon School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6102'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2700e18f-1aeb-5908-9daa-57199effe4c9',
  'Horace Allen School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6105'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e49d2e20-8b1c-5b82-a7ef-fa6e10bd2a72',
  'Crowsnest Consolidated High School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6106'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c94ec51e-758f-549c-92e4-f16b1544c098',
  'Livingstone School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6121'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4dd52e9d-a1b0-59e8-8b25-98319a12492f',
  'Matthew Halton High School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6122'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2bb03fdd-a015-58d4-8093-1c16f119ba3b',
  'Canyon Elementary School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6123'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0b5126de-1795-5534-9680-52fdf0acac0b',
  'Waterton New Yarrow Colony School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6124'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '33719acb-8a08-5e35-b3ae-0f3c46bd14cf',
  'Pincher Creek Sunset Colony',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6125'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '484cc931-d3dd-559c-96a5-98be8d45717b',
  'Spring Point Colony School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6126'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0e174e80-24a1-5f6a-9ce9-4f539f82a0a8',
  'Willow Creek Composite High School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6302'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '378107a6-3faf-5eaf-b8aa-b42529da1e2e',
  'Granum Schools',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6305'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c273706d-1b22-5b27-85ad-8d4f0bef5261',
  'F. P. Walshe School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6306'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4a69b953-8e43-5aa1-a161-d1e813818b21',
  'W. A. Day Elementary School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6308'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '91db09fe-5bb8-5cfa-badc-4ad15871026c',
  'J. T. Foster School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6310'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '704c4633-88bf-5bd8-8756-d0af25cff0be',
  'Stavely Elementary School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6311'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5b2e2795-2d0a-5c4f-9913-b4232bdb1d9b',
  'Ewelme Colony School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6313'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7c35d336-a2c8-53a3-b250-b8ccb5ddeb43',
  'Daly Creek Colony School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6314'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '027e5056-7beb-5096-9128-bb134b8ccecc',
  'Thompson Colony School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6315'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f2ada1b6-5269-57aa-8a4f-274bfe62a291',
  'Parkland Colony School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6316'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7c98da54-01e6-5dfd-a00d-d83b649c4ba9',
  'A B Daley Community School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6317'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6b87eb23-1c65-5cae-bf6a-1f644d5c2b1e',
  'Little Bow Colony School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6319'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '203a5ae2-fa81-5dc3-ac4a-7303c9ef9516',
  'Clear Lake Colony School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6320'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'df9c678c-7f05-52fd-8c1b-7fee69e77133',
  'West Meadow Elementary School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6321'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2ee7f69a-e2f3-5dc8-a72c-bf769401f2ca',
  'Willow Creek Colony School',
  '84e7f5d6-271b-505f-a5c4-9ab08abd77fe',
  'free',
  'Alberta Public school. Authority: The Livingstone Range School Division. Code: 6322'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7fe2ca3b-7bfb-5993-8aca-471d598620d0',
  'Vermilion Outreach School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 0533'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bc820b69-8a13-5020-9f07-2f859dbda412',
  'Rosewood Colony School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 2093'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '081503b7-96ea-55bf-a0f0-099d244fdb6e',
  'Delnorte School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3602'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '92e73e0c-b109-59d3-83d4-5ad5a38cd02f',
  'Mannville School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3604'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c9b965b0-ba6c-53a9-b13e-ed9cf74138c6',
  'Percy Lake Colony School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3614'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'acd5102e-8603-56d0-a6e0-19d952b36209',
  'Creighton Colony School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3616'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '22869e60-2840-5f32-a290-1cccff969845',
  'Dewberry School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3803'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2b2b34fa-479f-586e-874a-3e9356f1057a',
  'Kitscoty Elementary School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3805'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a641e5b9-31cb-5e77-abb5-df12553ec5c3',
  'Kitscoty Junior Senior High School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3806'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '044bbe83-9f0c-5dbe-9eaa-e3cc5da4cb16',
  'Marwayne Jubilee School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3808'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0e9a5ad6-60e6-5a38-92f3-14f6b15f84bf',
  'Autumn Leaf Colony School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3809'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0c89b729-ee00-55fd-9840-1fa4013d4d74',
  'E. H. Walter School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3811'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '54b88506-af43-5132-82ea-7a6fb809f3a9',
  'J. R. Robson School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3815'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '563af127-95da-56ee-8b8e-5d3a41973555',
  'Vermilion Elementary School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3816'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '67d6b395-7594-554a-8246-e7e9e288fcde',
  'South Ferriby Colony School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3821'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd3037a5d-bb5e-500f-a68a-d6aed3693c1f',
  'Dr. Folkins Community School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3902'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'aeb9f2d1-ea9a-56c2-8cac-6b9383a4d69f',
  'Edgerton Public School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3904'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a415de0b-8251-5c1e-be22-cadc593aea5b',
  'Irma School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3906'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b4bb377a-a298-5119-8c98-17266f00fcd1',
  'Wainwright High School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3909'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6b03619d-ff9f-505b-ae74-57a62af41b1d',
  'Wainwright Elementary School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3910'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '45117329-2a52-5ed5-a53d-745b578817ea',
  'Holt Colony School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3912'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1db704df-fd19-5d43-a389-e943a9769261',
  'Ribstone Colony School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 3913'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dee93328-dd25-55d3-a175-0b5b418b4112',
  'Amisk School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 4901'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2c1edf0b-87d1-5782-8288-80d4745cfa04',
  'Hughenden Public School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 4905'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3bf1a392-4557-522f-9226-5ad5f79af80c',
  'Provost Public School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 4907'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5da0efde-c613-5e91-ae61-1ded85566d10',
  'Highland View Colony School',
  '3f7ca054-0073-5289-80ef-8899fac82476',
  'free',
  'Alberta Public school. Authority: The Buffalo Trail School Division. Code: 4908'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9d8b2b60-26d1-5f97-9703-18dc3f92bcde',
  'Westlock Outreach',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 0019'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dbb46eaf-fc17-577b-8c57-7af17b792ca0',
  'Barrhead Composite High School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2301'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3c4900c8-401e-5665-9fbe-9c74ed25ce8f',
  'Barrhead Elementary School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2303'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0ae52e2d-7d84-53be-bed3-5743d10a0a77',
  'Dunstable School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2305'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0d045084-ef5d-51af-826a-1e222cb5db71',
  'Fort Assiniboine School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2306'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4dea7fce-c2e7-5723-8b3d-4108840ee675',
  'Neerlandia Public Christian School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2311'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5c87c234-fb69-58aa-b744-cf0c99b6b12d',
  'Barrhead Outreach',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2316'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e886d198-6a62-5276-b23e-1a160aa6b94b',
  'Vista Virtual School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2317'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3addd1d0-637a-5c9d-abda-b02cbea00dde',
  'Swan Hills School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2335'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '49381fea-7254-5c26-827a-9c0f2acc5abc',
  'Busby School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2401'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '00d5500d-6003-51bb-b7c6-e489124fd0a5',
  'Eleanor Hall School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2402'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3e68fa7e-8ecf-574b-a7e5-974912615fa5',
  'Pembina North Community School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2403'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e23370d6-d63a-5b4a-a7cf-1f8902e8237d',
  'Richard F Staples Secondary School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2411'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e1ff861b-9dab-5dad-995a-afb123848e17',
  'Westlock Elementary School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2413'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c9803cbe-1ea8-5492-a467-29300b1c99c6',
  'Pibroch Colony School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2415'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1fe95496-fa47-5959-be85-56e66cbf2c3c',
  'Sunny Bend Colony School',
  '48a856f7-6085-5790-8a0b-a7bc8d43da58',
  'free',
  'Alberta Public school. Authority: The Pembina Hills School Division. Code: 2416'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6c7e1d95-a4ff-5a95-9423-830aa4d8813e',
  'Heritage Heights School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 1131'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4235dfa1-a4af-5f23-9dc5-9ad542937418',
  'Westmount School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 1630'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bb59246d-5d53-5d49-b4f5-682b2f09504a',
  'Foothills Digital School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 1724'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '883bcddc-d813-525f-bd36-874930b3abd3',
  'Meadow Ridge School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 2250'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '71e88c2c-dd29-5563-8a7a-fe60233e588c',
  'Blackie School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5301'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e081163a-dbb7-5150-84c8-4ce536c72978',
  'Cayley School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5302'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '38674f25-0623-5c47-ad99-d502c54674f4',
  'Percy Pegler Elementary School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5303'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '65d58b33-25b8-5e75-a6cf-d1a20b71ff70',
  'Senator Riley School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5304'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bb242319-9e30-50fb-a32a-e9dd101e7f64',
  'Spitzee Elementary School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5305'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8e699a8d-e34f-51dd-bb0b-7e9a354822d7',
  'High River Colony School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5306'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '36e45288-b89f-5b7e-b15a-6de755364b0c',
  'Millarville Community School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5307'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '07cb4d70-2549-50e3-bc9a-f401ce8768a9',
  'Okotoks Junior High School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5308'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6119a6aa-2cb3-59ca-a182-f6c5c3bbf103',
  'Red Deer Lake School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5309'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ad0b2900-9d24-5162-862c-4e4e1106d229',
  'Oilfields High School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5310'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2b9b0a80-e356-5ca9-b0d0-6c8d0088a9ae',
  'Turner Valley Elementary Junior High School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5311'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2df84cd6-0174-5136-945c-fee935b46064',
  'C Ian McLaren School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5312'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '96b0dc61-212c-5785-9f16-2a3c23a7f0da',
  'Longview School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5313'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5bba76a6-815f-50d9-9f2f-b62084d4da3f',
  'Cayley Colony School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5314'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '52c5edff-af90-59ed-8b00-bfb066e0679f',
  'MacMillan Colony School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5315'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f8bffcef-bb64-5a22-b96a-14105ad27f02',
  'Right Honorable Joe Clark School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5316'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '301518e9-9f33-5846-b96f-2286f500800e',
  'Big Rock School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5318'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '88b58874-496f-5c4d-86ef-cf42722a2a40',
  'Foothills Composite High School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5319'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4f39c05b-a217-5251-998c-d1fc529335a9',
  'Dr Morris Gibson School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5321'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6064aad9-f3ab-57ca-b4d7-6435e04a15cb',
  'Ecole Secondaire Highwood High School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5322'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4366a2ee-e4da-5714-9ddc-e3859bac5b9e',
  'Alberta High School of Fine Arts',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5323'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1b0e9114-50b1-5db7-8768-df1c5a476532',
  'Cameron Crossing School',
  '6b570be1-9230-5e69-82c6-b920e560ebfe',
  'free',
  'Alberta Public school. Authority: The Foothills School Division. Code: 5326'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1561e512-bc24-5dcb-92c1-99dba4bc9ff3',
  'Ralph McCall School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 0336'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '990da1a0-9e04-52a1-a50d-7ce9cbb67bc1',
  'Airdrie Learning Connection',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 0404'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '43162591-69dd-540a-a413-ddc4c8550161',
  'Bow Valley High School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 0444'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '50a1fd4c-931b-5e80-b380-695d2c6383f3',
  'Bearspaw School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1030'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c81e13dd-49b5-5152-960a-8a6115f3823b',
  'Prairie Waters Elementary School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1042'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'def18552-3340-5f5d-aa1a-e3f9851724bf',
  'Langdon School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1117'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1db32d1d-9de8-5dcd-936f-681dfac1f055',
  'Nose Creek Elementary School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1342'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b2049020-52b8-58d1-b0ba-625b364799b2',
  'Rainbow Creek Elementary School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1413'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9dd95401-0943-57fb-b8c0-6c86d806e6dd',
  'Cochrane Christian Academy',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1584'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a1495c84-6ded-5b92-8107-77d4782e05da',
  'Sarah Thompson School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1673'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1363ff02-92ab-58f4-ba1a-621fef3aa085',
  'Herons Crossing School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1681'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fa946f2a-e8d1-5547-87bf-30e11d9121df',
  'Summit Trails Online High School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1735'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e8411d68-df13-5eac-b7a9-e608ea8bac7c',
  'East Lake School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1762'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c399faba-532c-5984-b801-b0f4b6b6c9cb',
  'C.W. Perry School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1763'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5b8b88c2-3de9-5cfd-a428-00cd35bea271',
  'W.H. Croxford High School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1764'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6553875b-d1a5-5cfe-9d96-00fb57d0be6f',
  'Coopers Crossing School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1977'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fd39d339-d287-5096-9413-08618ce40e66',
  'H. Lorimer School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1978'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dc8f6c97-2ae3-53d2-8422-ee0c89df8ab1',
  'RancheView School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 1998'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b2db25a7-a432-5301-b15c-2e0c40c98950',
  'Windsong Heights School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 2151'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '82dd36a5-8938-5dc6-b586-148bba9dc62b',
  'Fireside School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 2152'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd14a6c0c-a6cb-581b-b831-cd62457a80ae',
  'Northcott Prairie School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 2251'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b8ae9831-6458-5555-a8a4-5c068d1ba07e',
  'Discovery Trails Online School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 2419'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f0a807ad-0005-5f58-9478-3cb356ab0913',
  'Horseshoe Crossing High School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 2590'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dd3ab392-fe40-591a-a138-3d0ba6756302',
  'George McDougall High School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5201'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e4bacff2-35e7-51a4-85b5-9cbb02bb54c8',
  'Ecole Airdrie Middle School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5202'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e040e6c2-14d7-50b9-a8af-80089c1600b5',
  'Ecole Edwards Elementary School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5203'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5ab7e3c2-b69d-53ef-8dbd-1b3719ae095e',
  'Chestermere Lake Middle School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5204'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fd9eda7e-18df-56f5-99fb-d731a7e79650',
  'Beiseker Community School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5205'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '43d8a0cc-77e5-5427-934d-9f94bfdd082f',
  'Muriel Clayton Middle School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5206'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1b5ad952-65a4-5dda-bb17-f446d07acc3a',
  'R. J. Hawkey Elementary School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5207'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5d8a7f62-2eff-5776-9e28-12da1d5a46ad',
  'Chestermere High School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5208'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'aeeea9ee-e413-5624-b2f8-f0e97e327c01',
  'Cochrane High School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5209'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c7abc295-e887-59f4-9602-20c8883ba4a1',
  'Crossfield Elementary School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5212'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6e2bfc05-82e5-55ba-98d8-3eac4d382d5f',
  'Indus School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5213'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5176a9ca-61cb-5c6f-983a-556bdd291e3b',
  'Kathyrn School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5214'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9d0f2d64-2f58-508c-902b-3f9a3be2f0af',
  'Springbank Middle School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5215'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ea8d73c6-a431-5661-aceb-33135f2daa9e',
  'Elbow Valley Elementary School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5216'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dcbe797b-c468-57e4-a9f1-bdc34ee5b00b',
  'Westbrook School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5217'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9b18348c-883e-5a43-bdde-872570c9024f',
  'Beiseker Colony School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5218'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2e317068-f0b7-5ef4-854a-97d3d9422aa9',
  'Fairview Colony School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5219'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '416f478e-53a1-5e1e-8f75-4baeae2c6055',
  'Tschetter Colony School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5220'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c89b486f-0d93-5615-ba76-fb8f1eed03b9',
  'Manachaban Middle School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5221'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'efd0ba38-7796-5715-9ee1-d852836a8160',
  'Springbank Community High School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5223'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fb49d899-58ec-5c02-9ce1-64211aa26941',
  'Elizabeth Barrett Elementary School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5224'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '37c79563-5570-53dd-b277-2db05470afae',
  'W. G. Murdoch School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5225'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7c9968b6-9d8a-5e3e-8b4c-e30f4508427c',
  'Glenbow Elementary School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5226'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '66e64443-25f6-5e83-9364-64ff88092d10',
  'Bert Church High School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5228'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '82ca9429-a786-5ed8-aaa8-d05cb9a9f722',
  'Meadowbrook School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5229'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a5a047d8-073e-5863-9750-a5215723152b',
  'A. E. Bowers Elementary School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5230'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '30c2abe3-4728-5cb9-95ee-be75570ffcf5',
  'Mitford School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5231'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ff1ef31f-07e2-5926-b6fd-624a772710b7',
  'Banded Peak School',
  '0c329e56-ec16-59e1-b814-7fb2bbb526e1',
  'free',
  'Alberta Public school. Authority: The Rocky View School Division. Code: 5232'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bdf49e7b-2d26-5420-ba4a-77995e3d996d',
  'Lakeside Outreach School',
  '25e56639-065c-524c-b7f0-fe4f648e84cd',
  'free',
  'Alberta Public school. Authority: The High Prairie School Division. Code: 0375'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '80157d7a-5541-5d87-8cc0-850d1f0ee64e',
  'Prairie View Outreach School',
  '25e56639-065c-524c-b7f0-fe4f648e84cd',
  'free',
  'Alberta Public school. Authority: The High Prairie School Division. Code: 0435'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '96a1caeb-6135-5680-9c8b-c41eb0bba78b',
  'Georges P Vanier School',
  '25e56639-065c-524c-b7f0-fe4f648e84cd',
  'free',
  'Alberta Public school. Authority: The High Prairie School Division. Code: 1602'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0dfc194e-dd48-50fc-9fd4-7e8b07526c15',
  'E W Pratt High School',
  '25e56639-065c-524c-b7f0-fe4f648e84cd',
  'free',
  'Alberta Public school. Authority: The High Prairie School Division. Code: 1606'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '740adf1c-06b5-52ea-8821-1a449ed9e297',
  'Prairie River Junior High School',
  '25e56639-065c-524c-b7f0-fe4f648e84cd',
  'free',
  'Alberta Public school. Authority: The High Prairie School Division. Code: 1607'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'efd4576a-d8cc-5902-bf20-e7ef4d5ca787',
  'High Prairie Elementary School',
  '25e56639-065c-524c-b7f0-fe4f648e84cd',
  'free',
  'Alberta Public school. Authority: The High Prairie School Division. Code: 1608'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9075e359-33c2-5c89-9be1-32fd08d4227b',
  'Joussard School',
  '25e56639-065c-524c-b7f0-fe4f648e84cd',
  'free',
  'Alberta Public school. Authority: The High Prairie School Division. Code: 1610'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fcb5ab56-75c5-5f1c-9519-f8c6c1d2caec',
  'Kinuso School',
  '25e56639-065c-524c-b7f0-fe4f648e84cd',
  'free',
  'Alberta Public school. Authority: The High Prairie School Division. Code: 1611'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a8dd170b-8cbc-53fe-83fc-158bbe0ec8ed',
  'E G Wahlstrom School',
  '25e56639-065c-524c-b7f0-fe4f648e84cd',
  'free',
  'Alberta Public school. Authority: The High Prairie School Division. Code: 1614'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '888e58e1-500c-5f74-b93d-ffe39b0d0b41',
  'C J Schurter Elementary School',
  '25e56639-065c-524c-b7f0-fe4f648e84cd',
  'free',
  'Alberta Public school. Authority: The High Prairie School Division. Code: 1615'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e121f788-0a2d-590e-9cb0-be87fbc28338',
  'Roland Michener Secondary School',
  '25e56639-065c-524c-b7f0-fe4f648e84cd',
  'free',
  'Alberta Public school. Authority: The High Prairie School Division. Code: 1616'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a64f0366-4add-566b-956f-e32bdbc69d21',
  'Routhier School',
  '25e56639-065c-524c-b7f0-fe4f648e84cd',
  'free',
  'Alberta Public school. Authority: The High Prairie School Division. Code: 1635'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a61567e6-2a32-56d8-83fb-8f3acf4b3deb',
  'Crossroads Outreach School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 1242'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f8a59b9e-2884-5901-bbab-8d26946a8775',
  'Journeys Learning Academy',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 1443'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '358efad6-0bbb-5142-ae39-5a994790b64a',
  'Art Smith Aviation Academy',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 1545'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bae7517d-68d9-5727-81b7-516fd3716d46',
  'Pine Meadow Hutterite School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 1738'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6baa2bf5-69d1-5837-8321-44f988ad2229',
  'Aurora Middle School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 1800'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b4bb2c10-7ad8-5fb6-b598-5bb3c7677e30',
  'Learning Together Anywhere School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2386'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f7c8d6da-3e73-56d4-ad66-a26b33054c7a',
  'Caslan School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2701'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'aa873352-883a-51e5-b610-7b77a55d6a35',
  'J A Williams High School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2702'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0c005b85-57b5-5fdd-96a9-4fa2d41abd16',
  'Vera M. Welsh Elementary School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2704'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '79c66b28-3b8c-5d6a-8c19-ded339aa4df3',
  'Ecole Plamondon School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2706'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4dfb7a71-464e-53d7-9843-c108cf387329',
  'Wandering River School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2708'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dc0c6170-f867-588d-a936-2b376e59c386',
  'Kikino Elementary School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2717'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2f042801-1628-527e-82a5-7afcb8b347f9',
  'Lac La Biche Outreach',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2719'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '371fc2dd-9eaf-5b46-9d8f-4764906371f0',
  'Bonnyville Outreach',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2720'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b760c126-2570-50e1-9fc5-1bb9605a714f',
  'Cold Lake Outreach',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2726'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '23698f9d-d1cc-55ed-9372-757190d51cf8',
  'Ardmore School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2901'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0aadcdbd-b1c5-53e6-a44a-88152ce73b7c',
  'Cold Lake Elementary School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2902'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1f02c7d5-dd30-578b-809b-530595b5bcdf',
  'Duclos School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2903'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e40b3206-5474-5ddc-8e4b-655c53bdc4e7',
  'Glendon School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2905'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1ccbcbb0-f2bc-5786-9bd1-eb63d60f8a16',
  'Cold Lake High School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2906'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b7b25eae-f1c2-557b-941b-7dbce05988db',
  'North Star Elementary School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2907'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '41d8c36b-d5e7-51af-9661-78f69808abb1',
  'Iron River School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2908'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '66a4da51-e841-57b6-96ea-d59ce2eba0a9',
  'Cold Lake Junior High School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2909'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '342fbde8-2d47-5e48-b7f5-12f1f7e55591',
  'H E Bourgoin Middle School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2911'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '410f075a-8a80-55d7-8358-2b88ae444db1',
  'Nelson Heights Middle School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2912'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '66ad40b8-e601-5cb0-804b-65e9d0f170f8',
  'Bonnyville Centralized High School',
  '12d0103b-ff38-5a99-8f4d-e9ed05ac17a3',
  'free',
  'Alberta Public school. Authority: The Northern Lights School Division. Code: 2950'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '57d68a32-5f04-5593-b11e-bc97eb95f763',
  'Spirit of the North Community School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 0487'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c32362c8-ba92-5618-8a4e-1ae3492a3376',
  'Buffalo Head Prairie School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1701'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c7efc44b-dc94-56ff-8d13-94e5f60adcb5',
  'Fort Vermilion Public School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1702'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '88547558-2885-5d25-a5d1-b82de38e6270',
  'High Level Public School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1703'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a15f37e1-18dc-59c0-aafb-cc6f94deebd7',
  'La Crete Public School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1704'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '56e1a180-89be-526c-9408-1f734af22164',
  'Rainbow Lake School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1705'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7555dc90-a2bd-59d4-88cc-e0dd643d60ac',
  'Rocky Lane School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1706'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3c07cb5e-a4ab-5c23-8164-145e12aed926',
  'Florence MacDougall Community School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1709'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '23b8d1d6-53fd-5e11-b70b-7cb38a45d5da',
  'Hill Crest Community School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1712'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'caad878e-7b49-5e48-ab2c-06a37e512fde',
  'Blue Hills Community School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1713'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4b6ec6ac-8e96-547a-ac99-99db3d762097',
  'Ridgeview Central School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1714'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2e2fce98-16cd-5af7-be25-1c5e55faf90a',
  'Northern Outreach Center',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1742'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b6219ebb-984d-54b0-be7d-4085d659b241',
  'St. Mary’s Catholic School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1770'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fa658180-0e43-5eae-9f0c-aba1fdec807c',
  'Upper Hay River School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1791'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e90b9462-5f60-5c0c-956d-518dcfecb458',
  'Sand Hills Elementary School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 1794'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6892baca-e51f-52c9-8c8b-b3f9c3029c37',
  'Pathways School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 2454'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b1a96919-eff4-54f3-bf8b-16334c7cc869',
  'De Oabeit Collegiate School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 2633'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd4f37623-a147-5d42-b9eb-3844aabe2518',
  'Gramson Centre Collegiate School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 2634'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f3f08715-c93b-57ce-a7d3-45f013f15d49',
  'Sipiwan Centre 15 Collegiate School',
  'd5efcfa0-6bd0-5c8b-8f56-edcb3daa8050',
  'free',
  'Alberta Public school. Authority: The Fort Vermilion School Division. Code: 2635'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5f7b12bf-797e-55fe-bd0a-8ea58ef72767',
  'Hillview School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1379'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '71ace162-9d6e-5202-8dad-2367cca1ca69',
  'Mistassiniy Outreach Program',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1543'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5cf04979-92c2-5155-8af1-ae36bfa3db1b',
  'Bill Woodward School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1544'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd879ad2f-9148-52ff-8660-b7224c12f752',
  'Anzac School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1801'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e9f21e86-cffc-5c17-bceb-7d6b1ec220d2',
  'Calling Lake School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1804'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f652c6c6-0af0-5512-8f75-bf15676e7c25',
  'Chipewyan Lake School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1805'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4aa7a333-d770-5636-84c8-8b04fa17bcda',
  'Conklin Community School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1806'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e5f99b39-5756-5026-ae59-91841d63fac7',
  'Mistassiniy School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1807'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5fe32fb3-832b-530b-b198-e74412310cd1',
  'Elizabeth Community School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1808'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6ebf0e7f-4de1-5a6c-b538-f532da840e65',
  'J F Dion School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1809'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e1adda7a-ef14-5f87-889f-d12cef829fe6',
  'Gift Lake School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1817'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4a220fbb-c567-548e-8f0c-761da7f5a92a',
  'Grouard Northland School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1818'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'af5f7977-7b44-5f21-885e-2c988bf42d16',
  'Father R Perin School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1820'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '355dc4e8-5223-5630-8f3d-7f86410e14c4',
  'Paddle Prairie School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1827'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b0e98a98-2441-5b44-be26-4c829d2df2cb',
  'Susa Creek School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1830'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f99f0eb3-07eb-5f8e-a3b2-744948b67c3f',
  'Bishop Routhier School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1833'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '41a56395-f9bc-5922-9098-9816c41cc2ad',
  'St. Theresa School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 1834'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '38d4d50c-b267-5912-81b3-97dcf1bb8f9a',
  'Northland Online School',
  '273b9f5e-13c9-5903-b17b-8b6b88d2c5e6',
  'free',
  'Alberta Public school. Authority: The Northland School Division. Code: 2381'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '06052350-429e-55a2-a7bf-62eb2d863674',
  'Visions West School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 0531'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0ac45600-e117-5496-a462-4b7b3e632d43',
  'Drayton Valley Community Outreach School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 1017'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2865c51f-0f31-5ae9-a828-ed150810d095',
  'Frank Maddock High School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 2201'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0c5ea806-d39c-5bbb-b641-d37c4f3e852e',
  'H W Pickup Junior High School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 2202'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f218a22c-8885-525a-aae8-b485e16e5430',
  'Evergreen Elementary School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 2203'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '69a4b26b-2df7-5bc2-a518-9c4e245a66d6',
  'Aurora Elementary School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 2231'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '825491d8-b5f6-5651-9b2d-2136dd429fab',
  'Drayton Christian School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 2289'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '83b2e0c5-45d1-5c99-b61c-e2be89ffad22',
  'Breton High School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 3202'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd432ef1c-f2b0-561e-a381-6d4aec3fa875',
  'Breton Elementary School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 3203'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c45d1070-2006-5a36-b343-5dee00a012f7',
  'Caroline School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 4101'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ebc471ab-3070-5bc6-84a0-80c0dfef7124',
  'David Thompson School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 4102'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ad62d92e-f5d8-5266-ab61-537ca847c697',
  'Charlotte Small Elementary School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 4103'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd40a8276-73de-59df-9d80-434f7a3cd14d',
  'West Central High School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 4105'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3f2db5db-784b-56b1-8acb-f355afafea65',
  'Ecole Rocky Elementary School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 4106'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '05b3193c-f2d3-5ead-ace9-edfbb8d6bd0c',
  'Lochearn Elementary School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 4107'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd3cfdc65-a573-56bf-9ca8-de84ede0a8ee',
  'Pioneer School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 4109'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '25cfdd5a-8688-5dde-a54e-31244ae55bb1',
  'Kootenay School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 4111'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '18cca2dd-dc97-5d58-9a0d-1bbaf548fa05',
  'Rocky Christian School',
  '8a1d96d0-6d1c-582e-aafc-4b665d4a2eb9',
  'free',
  'Alberta Public school. Authority: The Wild Rose School Division. Code: 4192'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '09deb773-6eb3-541f-a8b1-b897e69b164c',
  'Lathom Colony School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 1122'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '70bea914-7906-58e1-a009-93ebb0da0e3f',
  'Uplands Elementary School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 1773'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ff55a745-8fc3-55f4-93a2-05601e2ada24',
  'Alcoma School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6701'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '67b7dbfb-ffee-56de-930f-e4a110ce405e',
  'Bassano School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6702'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ad3c1473-6483-5e2b-a167-5062d4040be3',
  'Duchess School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6703'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7cc98dbd-2030-506e-a6a0-93c6e6e20473',
  'Rolling Hills School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6704'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd223d026-e13f-569d-b0e2-ee39549e7ba6',
  'Gem School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6705'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f0339f24-d012-5db4-ac1d-b91c93ea9c68',
  'Rosemary School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6708'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '37705bbe-f132-590b-8567-277474eeab90',
  'Tilley School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6709'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '50779fc6-c59c-5b0c-9429-29147defcb24',
  'Bow City Colony School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6711'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '06b5f491-35f0-5b57-970e-97008e4dbeb5',
  'Newell Colony School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6712'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e030ca4f-a369-547d-9799-8d950efe9063',
  'Springside Colony School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6713'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6990ed0c-2d37-532f-b74d-e789db05174c',
  'Fairville Colony School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6717'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4e8d9c7f-3423-5f80-b71d-5fc99b13112e',
  'Sunrise School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6718'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8251ce73-491f-5745-ac7a-0ad0450deef9',
  'Brooks Composite High School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6740'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c456bf77-21cd-58b7-858b-82b73f25785a',
  'Brooks Junior High School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6741'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7e8009e4-7a0f-5f6b-96ea-73d879949c12',
  'Eastbrook Elementary School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6744'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9fe2b508-d417-5cfc-a89b-092b369e462d',
  'Griffin Park School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6745'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd1211d80-76cf-5bdb-b344-d6e9595a473d',
  'Clearview Colony School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6790'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '103dffb5-8dc8-5a13-9cd3-f244aee6a921',
  'Springview Colony School',
  '870bfe9b-fc78-55e3-a92c-b9ac69c65522',
  'free',
  'Alberta Public school. Authority: The Grasslands School Division. Code: 6791'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b0c1fffc-b4aa-5861-9f26-e10835683e88',
  'Pine Haven School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 0312'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '543dd385-ecea-5109-b6f1-3e547aec4c0d',
  'Lynn Lauren School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 1300'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '983ca5eb-89cf-5a18-820b-6ec4852867d1',
  'Silver Creek School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 1447'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9d099f26-4991-5e25-ab11-02c677698d39',
  'Alder Flats Elementary School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3101'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b82d91b2-4441-516a-95b0-3a5a720b45cb',
  'Buck Mountain Central School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3102'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'db913d53-aaf7-5f06-936a-beb5ac53b4b5',
  'Clear Vista School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3103'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd7659a05-0b3e-58dd-a455-eed270b6af50',
  'Pigeon Lake Regional',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3104'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ccbaca83-091f-5ee4-b4e9-e6acd1e7e5fb',
  'Falun School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3105'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0978f1c5-3f46-58c1-bb07-eede68485c4f',
  'Lakedell School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3107'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cbe33fd1-362e-5d77-a4d1-c94db9811986',
  'Pipestone School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3109'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8d513fc2-ba41-5efe-8ccc-9fed6572e032',
  'Winfield Elementary School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3111'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ee63cab6-1677-5fd1-9350-d3244b7f3a92',
  'Griffiths-Scott School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3112'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dee973d4-3926-57be-986a-61c3fcc15b98',
  'Parkdale School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3142'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b0fee583-4b16-5a6c-a60b-c33208a767e4',
  'Queen Elizabeth School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3143'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5e25dd3a-b7df-577a-96df-9be69b926f6f',
  'Wetaskiwin Composite High School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3144'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fcbcad5c-2b57-5fdc-afca-76c5450855f0',
  'Centennial School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3145'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dffcd202-f246-522e-b6ec-5b87ddb01ce1',
  'Norwood School',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3146'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1351bb6c-d318-5ba3-80a9-5bf510005c96',
  'Wetaskiwin Outreach',
  '44e08c49-d3b1-5dd7-8ec8-682d5bd7f2e9',
  'free',
  'Alberta Public school. Authority: The Wetaskiwin School Division. Code: 3148'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ef688ec5-d817-5b02-8a48-036af0e2a460',
  'Centre for Alternative and Virtual Education',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 1546'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd5a67bcc-789e-5204-a463-74d901e86681',
  'Vilna Off-Campus Achievement Academy',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 1547'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ad6d9c3a-45c5-5191-a2de-8bada15a3389',
  'New Pine Creek Colony',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 1938'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5ca239ee-0e60-57fd-9887-9f755a46d21e',
  'Deep Creek Colony School',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 2161'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '566644db-9962-5073-85bb-ed93bea6b5fe',
  'Edwin Parr Composite Community School',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 2601'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'af8cf7f2-f70b-538f-a2f3-f301a3aebcde',
  'Landing Trail Intermediate School',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 2602'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c3054657-a92a-59f7-a940-78a3b43def97',
  'Boyle School',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 2604'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0d94046f-25f1-51b9-9233-0e3fb3384bd2',
  'Grassland Community School',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 2605'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fc35159e-b788-56ef-a329-9f005af380cf',
  'Rochester School',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 2608'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '896e5f2a-6394-564b-9ca3-c6fd7e4e0165',
  'Smith School',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 2609'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fbe0b13a-ffbb-50cb-8f97-e80a6deda1bd',
  'Athabasca Colony School',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 2610'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0e86bd56-2bfe-523d-afdf-d08898b53350',
  'Whispering Hills Primary School',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 2611'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'be8a3f3d-1c65-50f2-a7ef-d662ec3f0f43',
  'Thorhild Central School',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 2624'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '403d0ec8-bfd8-5e03-9ecd-912cf812c67c',
  'H. A. Kostash School',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 2722'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'df9048fb-4ed9-5de6-b89c-ee5b2724c647',
  'Vilna School',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 2724'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '79fd07da-4d94-59ab-a97c-2d7234d7958e',
  'Hutterite Colony School',
  'f322b731-cde8-55b2-99b3-1691df95e0a9',
  'free',
  'Alberta Public school. Authority: The Aspen View School Division. Code: 2727'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5cc849e6-f3b0-531f-834d-5505eadb3b83',
  'Glenrose Colony School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 0341'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c568762b-f07c-5d5b-b220-a61665a7072b',
  'Twin Creeks School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 0342'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bdaacb7c-adb6-5eab-af00-2ace2e98274a',
  'Golden Hills Learning Academy',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 0384'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ca48b646-0700-502a-94b6-7b6e5b633893',
  'Wintering Hills',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 0575'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2670d765-2a9b-5438-9159-adf6756702b8',
  'Mountainview School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 0592'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cee29aba-8c70-5dda-86d0-f646300d4d20',
  'Strathmore High School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 0660'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '57189a6b-627a-502e-9999-4865881f282b',
  'NorthStar Academy',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 1016'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '30f663fa-c43c-52d5-b274-795fcffd2984',
  'Green Acres School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 1077'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '57d61467-f761-5838-9d45-89bf8be49804',
  'Three Hills Colony School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 1360'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8fd9291e-d65e-5460-b865-9aaff0dd8971',
  'Trinity Christian Academy',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 1433'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '55742905-b5eb-5eb2-a870-5a09b10595d2',
  'Wheatland Crossing School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 2071'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c2e7e70d-acac-5216-9c69-b9f3f9d995bb',
  'Anchors Outreach School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 2162'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3ffbe469-3371-5a0c-bcc2-c83b5f77e51c',
  'George Freeman School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 2196'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6a7f78fb-d189-5a22-9a44-aee57a4f1fc0',
  'Country Hills School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 2243'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c76479f0-ec3e-52d9-9880-a58937472dca',
  'Carseland School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5501'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e45ab91a-838a-5ce0-ad51-7a0163e363a4',
  'Westmount School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5510'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4c71098a-e8ea-5c16-adc3-43969b2c2f85',
  'Sayre School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5511'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '90a50d8b-9010-54ae-80e1-37c9531adfbc',
  'Sandhills School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5512'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'eef33378-fa72-5d6e-bebc-450844ff226c',
  'Towers School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5513'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c67ccb28-950e-55f3-a632-d938108b7262',
  'Rosebud River School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5514'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7a55c0db-58e3-57a1-afe0-eb96261713b7',
  'Hines School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5515'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '502d8643-11b1-5f0f-944d-74228bd0f376',
  'Rising Sun School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5516'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b9250e09-d3f4-51e6-8442-5538c485d313',
  'École Brentwood Elementary School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5517'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7c5a1989-8772-5b2f-9ea7-62b3a1e9d270',
  'Crowther Memorial Junior High School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5519'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '480d4024-aa4b-577c-b488-050bff772741',
  'Poplar Row School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5520'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '998f4a10-e475-54e8-a740-01a57bda3f6f',
  'Rosebud Creek School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5522'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fe720d2d-cda0-575f-b5a9-78959497c921',
  'Crawling Valley School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5523'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0975f255-8e11-51e1-b8f3-b10576abba6d',
  'Wheatland Elementary School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5525'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3eb1067b-a4c6-5607-9270-04bd7e43802e',
  'Drumheller Outreach',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5526'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6bb86a10-c62c-51d3-9082-015c88bcf798',
  'Strathmore Store Front School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5527'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5972d76b-15ee-559b-88a1-f260e58a1cf7',
  'Acme School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5601'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9fa6a3c4-c430-51e2-9cc5-f00e53dc925b',
  'Carbon School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5602'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '21b18e1e-ac8b-5da5-9826-2d6a495fee5d',
  'Britestone Hutterite Colony',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5606'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c411f182-34b6-571d-b7fe-f4176f97d8c8',
  'Dr Elliott Community School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5607'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '523b300a-5548-5eae-bb17-0423fe3398c9',
  'Three Hills School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5610'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9911e6c0-6a96-58d8-92a9-f24db1a3be31',
  'Trochu Valley School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5612'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a8956e9f-fdd0-5f07-8939-1f41b296e43b',
  'Huxley Colony School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5615'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3cd45e2c-bcd9-51bd-9a3f-0163d017c223',
  'Valleyview Colony School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5616'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4a3cd169-942b-5be5-b0a0-2b38d4b5d5dc',
  'Prairie Christian Academy',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5691'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2a3c3cb1-0168-50f9-a179-5a24bf00f837',
  'Drumheller Valley Secondary School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5725'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8fc2d5c1-72ac-5eef-816d-dd2d678a70d8',
  'Greentree School',
  'b0c74b61-b717-5198-a468-3ae4d6f60dfc',
  'free',
  'Alberta Public school. Authority: The Golden Hills School Division. Code: 5726'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5083d1cb-0237-59dc-8683-e6d81e0a6d81',
  'Two Hills Mennonite School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 0532'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b73229a4-a9a4-52bd-9505-4d5c7f8ea7d2',
  'Elk Point Outreach',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 1381'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9153f180-5251-5adc-909e-415ed678c099',
  'Myrnam Outreach Program',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 2238'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8ebbedd3-d50d-5a96-8cea-bc27a908148b',
  'Stony Creek Hutterite Colony School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 2393'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dd5d55d4-39d0-551d-90e6-a3e9b3e3a4b7',
  'Ashmont School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 2800'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0d61f440-cdf1-51ab-b4bb-5b3de7822123',
  'F.G. Miller Junior Senior High School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 2802'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '78b8f0d2-78a2-5a55-991f-bc686ddd0490',
  'Elk Point Elementary School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 2803'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2cb43fe1-2f2e-50be-9bdb-ba12b826fcc6',
  'Heinsburg Community School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 2804'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '836b2f92-5d02-5eeb-b14b-914c699033a6',
  'Ecole Mallaig Community School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 2806'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3aac3109-6f4d-5ecd-a6eb-8f4136e2dfe9',
  'St. Paul Alternate Education Centre',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 2808'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3901d192-13f1-5ce8-9998-d08d58a3995c',
  'Hairy Hill Colony School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 2809'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a099b550-c031-5fa2-a9b6-755818a2a924',
  'Ecole Regionale St. Paul Regional High School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 2820'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '53b12405-5837-541a-a165-9f65fcb944e7',
  'Glen Avon Protestant School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 2835'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b8bbaff3-74c3-568c-9537-12934d6edc6d',
  'Racette Junior High School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 2871'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c5227353-8a0b-56b2-994d-08b9e3e770ed',
  'Ecole Elementaire St. Paul Elementary School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 2872'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3a0fe80e-1385-5ea1-89ab-d7d7455d4f1d',
  'New Myrnam School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 3703'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'af6cc8ab-5504-59ee-bbc1-5c6a78b2f088',
  'Two Hills School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 3707'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9e50fe14-cd69-5b68-9911-d36f95f2d1f8',
  'Plain Lake Colony School',
  'fa923d2d-03c8-593a-bdf6-d88545d92471',
  'free',
  'Alberta Public school. Authority: The St. Paul School Division. Code: 3711'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b85d4c62-18c7-5122-863c-355c02fc8446',
  'Vegreville Next Step III Outreach School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 0401'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f8aaddb7-9404-5149-8200-d64d5c525d0a',
  'Lakeland Ridge School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 1221'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fd32f196-6b94-5b21-8627-d55bcab8a2a0',
  'Strathcona Christian Academy Elementary School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 1367'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0d2390b8-629a-56c3-8316-d779768b5539',
  'Elk Island Youth Ranch Learning Centre',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 1599'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '326418fa-41d9-57cb-bee9-edb4c2e4934e',
  'Rudolph Hennig Junior High School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 1752'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '09eeace6-8b1f-562d-8a9f-73362fdfc69b',
  'Ecole Parc Elementaire',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 1753'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd00c9139-9a1e-5fa9-b13a-f90193249ec1',
  'SouthPointe School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 2136'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '78e8c586-30ec-5849-bab8-8e1e9fbff0fb',
  'Davidson Creek Elementary School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 2182'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0f62e6bc-256b-5bc3-a74c-1e50edffeae8',
  'Heritage Hills Elementary School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 2252'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '33907467-dbfe-5865-b0c7-26ab59863865',
  'Salisbury STEPS Junior/Senior High school',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 2399'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '00514f92-efe2-5bb6-9cd1-4c97a80bb93c',
  'Ardrossan Junior Senior High School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3301'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '78ad21b1-f454-5a3e-b265-7ef66a1687a8',
  'Ardrossan Elementary School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3303'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '19bf5dab-8aff-57b1-8ce2-a588de5ff8a3',
  'Uncas Elementary School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3304'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bc1e8432-16cc-54e8-92ef-fd2202961c0a',
  'Sherwood Park Next Step I Outreach School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3307'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7eb47d04-16b2-5ad5-a9fc-5e910ed4287d',
  'Fort Saskatchewan Next Step II Outreach School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3310'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3757d8c2-e01a-5f27-a1b8-749842679a0f',
  'Fort Saskatchewan High School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3311'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5f2c43b2-401a-55f8-8159-1910e26f8d90',
  'Fort Saskatchewan Elementary School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3313'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '91e93a57-6559-54f8-8bad-ae6f3ba740a8',
  'Win Ferguson Community School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3316'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '83e604b6-15fc-522b-accf-27e02f5e2d08',
  'F. R. Haythorne School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3321'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1aae7fa1-0c1b-5f51-a000-9ef18636c806',
  'Salisbury Composite High School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3322'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd38bafe8-e0b0-5dad-872a-ca8e90a4f7bd',
  'Sherwood Heights Junior High School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3323'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ac123302-2fda-5be8-885d-5c35d1a01ab0',
  'Brentwood School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3324'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3a6d5fbd-40b9-5801-a7a0-ebd272bdbe1f',
  'Ecole Campbelltown School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3325'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '60a65de2-c1ee-551d-a0d0-ff9d6c3a267a',
  'Pine Street School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3326'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4722632c-c9a5-5803-9414-556c1c0a094b',
  'Westboro Elementary School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3328'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '469f2eea-fbd0-57f5-a135-8936018e911b',
  'Mills Haven Elementary School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3329'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3d687a05-efd2-5d45-a4c5-5f63f2f4b579',
  'Clover Bar Junior High School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3330'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '394f7c32-c93d-5ce3-877e-46d15cc244dd',
  'Castle School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3332'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '44ab5dbe-bc7f-5770-be41-2973f2660f5c',
  'Glen Allan Elementary School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3333'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ad395bc6-c3e3-58b2-a582-eeadaad90d34',
  'Wes Hosford School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3334'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f7fb640c-c59c-5b3a-8779-585aecdc7489',
  'Fultonvale Elementary Junior High School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3335'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dad40e79-0cb5-5551-a3ed-e01e8faa4729',
  'Woodbridge Farms School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3336'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b65a5624-ea45-53fa-a021-46e74bd9adec',
  'Bev Facey Community High School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3340'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c0149d8d-32c3-5f16-be6c-cf0be94d2dc9',
  'James Mowat School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3341'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e0130e83-9d86-5373-aa72-83c715586be1',
  'Strathcona Christian Academy',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3395'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'adb504e2-3285-5996-b41b-1c5b83de60bc',
  'Fort Saskatchewan Christian School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3397'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '38b9465d-19cd-50e4-9aa0-3ad9294161ed',
  'Lamont High School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3404'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5dbc4154-2710-5d95-817f-f26f6688ee09',
  'Lamont Elementary School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3405'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9ddec695-e60e-5eff-a85a-63dad3fc19ce',
  'Mundare School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3406'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2bdeb8fa-8a59-5ad2-9086-46ec47a7768f',
  'Bruderheim Community School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3409'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5c15c82c-bd6b-5320-a491-09dc17f4beec',
  'Vegreville Composite High School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3610'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9af786d2-74d9-5e52-894e-19797bc52fb3',
  'A. L. Horton Elementary School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3611'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7d16df42-2bb3-551e-8623-594c533abd05',
  'Pleasant Ridge Colony School',
  'a0a115c3-5440-52dc-b79d-d4d6d8bb7eb4',
  'free',
  'Alberta Public school. Authority: The Elk Island School Division. Code: 3615'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '36fb8cdf-2487-5140-810f-5c0bf928db13',
  'Calmar Elementary School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 1279'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '72977147-bf70-5a0f-8576-ec8f4abc110b',
  'Black Gold Outreach - Beaumont',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 1689'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '954470b1-219f-5cc0-9dd6-be95f15f8ce9',
  'Ecole Dansereau Meadows School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 1766'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd2c942b9-edaa-541e-9ba5-184b7d9005e9',
  'West Haven Public School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 2065'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8a61b7b4-bcac-542a-b6aa-b4be7ba8e8a9',
  'École Champs Vallée School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 2150'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bf3ff050-570f-5066-8541-05b79751ed71',
  'Ohpaho Secondary School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 2564'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4f808c1b-2c6c-51c0-8888-68fe49a00dd6',
  'Black Gold Home-Based School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3000'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5ccecbf0-54b1-5614-8313-8f89bf303a91',
  'Ecole Bellevue School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3201'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd86d0fe8-8a3f-5297-8403-f3ba83c5bea9',
  'Ecole J E Lapointe School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3204'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cf7ab8f1-0f95-5b1d-bbcf-7c2ad4d6a231',
  'Calmar Secondary School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3206'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ff0d7da4-2999-5117-86d8-5f97bf76c6c0',
  'Caledonia Park School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3210'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f036543e-bf53-53cb-be9e-6f4b8b56f3ae',
  'Ecole Corinthia Park School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3211'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9083e214-baa5-51d3-9f97-18b4582c09ec',
  'Leduc Composite High School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3212'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '41acf5c6-9d7f-5a70-bfaf-d8627dda76b0',
  'Ecole Leduc Junior High School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3213'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a7805f11-21ce-517d-9779-fdeefab207d0',
  'East Elementary School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3214'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b2ab275f-80f5-5616-9f15-565327d71dfd',
  'Linsford Park School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3215'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '90d3219f-19f5-55b3-8b8f-46374f8ae69a',
  'Willow Park School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3217'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ebfcacd3-75eb-504e-bcc0-2d027eccdeef',
  'New Sarepta Community High School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3220'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '11b9229d-322f-5bea-9fc3-46640088599e',
  'New Sarepta Elementary School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3221'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f2732f95-cdea-5a04-9c3d-71a6aafce266',
  'Thorsby Junior Senior High School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3222'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c3b09ecc-f9a4-52e0-bf99-dac1c1e1f475',
  'Thorsby Elementary School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3223'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '40e1b58c-0110-51cb-841d-bf097d9dbcc5',
  'Ecole Beau Meadow School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3224'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '57a56ecf-a89c-5f3c-a775-501c8101b3cd',
  'Warburg School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3226'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e00fc8cc-e746-5fa5-bd7f-44b82dcd9071',
  'Warburg Colony School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3228'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bd48b246-fb70-5792-81c2-fe4bad372468',
  'Ecole Secondaire Beaumont Composite High School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3231'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9ee5e38f-ba18-5cc8-93fd-be9ff0f93605',
  'École Leduc Estates School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3232'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b1050a84-e947-51d5-8e1f-eb8ad8fb19bb',
  'Ecole Coloniale Estates School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3234'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c7db43d0-f942-56b2-9387-64d0133303f0',
  'John Maland High School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3235'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2a1c30d1-7e56-5ad1-a130-54b5ae304260',
  'Robina Baker Elementary School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3236'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3b77ad0d-93f7-5d25-8764-4f7e0f62589e',
  'Riverview Middle School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3237'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'af5abd1c-dd96-58c6-af93-97e38da8f40f',
  'Black Gold Outreach School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 3238'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c9ceb806-3ccd-5131-bc66-5772d42fd73d',
  'Covenant Christian School',
  '9837e4d8-6d6e-518f-875f-8bddc22cdca6',
  'free',
  'Alberta Public school. Authority: The Black Gold School Division. Code: 9943'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bf70ede2-f751-5222-b43c-800325ebe870',
  'Master''s Academy',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 0030'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '83fa48b5-0d49-542a-89d9-c8eff9395fa0',
  'Arrowwood Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 1419'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd47226e8-29e3-5386-a54a-8f8c088a1436',
  'Barons School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 1423'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a73e6be0-3b30-5770-bedd-75dd613e9021',
  'Albion Ridge Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 1472'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '890a6177-9744-5431-bf98-fa348010f995',
  'Carmangay School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 1538'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8ec7ab4b-f048-5262-a4b8-79a51904e645',
  'Shadow Ranch Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 1541'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7ffa874b-4df8-5ee6-ae52-6444d2337634',
  'Master''s College',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 1562'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '50296606-91bb-5239-9f89-7901b2ff68bd',
  'Skylight Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 1720'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '518b8bb7-4794-5891-8370-4abe27e73413',
  'Calgary Islamic School, Omar Bin Al-Khattab Campus',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 1722'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '95e29ed2-a3a3-55c6-98b8-a219e80f0d8b',
  'Palliser Beyond Borders',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 1772'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5f48ec15-49dd-5043-9bc3-03ff31480ae4',
  'Horizon Leadership Academy',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 2164'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6ee240de-71ce-5f25-9550-1d5e6471e75a',
  'National Sport School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 2410'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bf79d969-e72d-5388-93b7-267762e58674',
  'Coaldale Prairie Winds Secondary',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 2596'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6b472a6c-09e5-5eab-b2a5-0f0346dd2317',
  'Southern Alberta Collegiate Institute',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 2630'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9de1249a-2694-5ac9-af5d-fe5291129a47',
  'Arrowwood Community School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 5401'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '95d9ac08-6c63-5425-98b3-09ee01f93f0b',
  'Champion School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 5404'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a554150b-86e1-5dee-aa99-1e753d064e0c',
  'Milo Community School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 5406'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fd836c10-7b73-5a05-8451-f735cdd8750d',
  'County Central High School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 5410'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd7a59b13-16ea-5a84-8b3c-cef053d93b56',
  'Vulcan Prairieview Elementary School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 5411'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8802eb3d-aae3-588a-a0c0-a21208d2d7c9',
  'New Dale Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 5412'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1c2e1247-2a02-5f9e-a95a-7009939dc312',
  'Riverbend Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 5413'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c42920b7-0d26-5811-8e8a-399bdac72e15',
  'Mialta Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 5416'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e4360565-20a9-53eb-9536-742402361c19',
  'Wild Rose Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 5417'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ea1e3127-4911-5ac7-975b-40703008d6fb',
  'Keho Lake Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 5436'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '765fab90-7a6d-5206-9437-777f666af089',
  'Springridge Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 5490'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6d535248-271c-5cd6-8959-aefd4478e7e0',
  'Brant Christian School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 5492'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b028214b-3c6e-548f-87be-41652441e59b',
  'Brant Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6390'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ff3380d8-097b-52f7-9762-37c1da9ca9d6',
  'R. I. Baker Middle School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6402'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6e247d70-ca72-51d6-91db-b0ecf174f98f',
  'John Davidson School Program',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6403'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd96a535c-9c46-541a-b3a7-c555852eb931',
  'Jennie Emery Elementary School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6404'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '092b0b1b-0fdc-563a-b7be-444610300959',
  'Coalhurst High School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6405'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '480b7e21-2e05-513b-9916-54f4426037f5',
  'Coalhurst Elementary School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6406'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '017895fc-9e3d-5931-8e92-f9b76221a3ba',
  'Sunnyside School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6407'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7792aba8-c856-5bf3-8713-c56ee3318ff0',
  'Huntsville School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6409'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9f8e0fcc-e6b1-5d5c-91e2-80499a8ad7b1',
  'Noble Central School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6410'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '045ec78c-4173-55be-b8aa-8c0375ec2116',
  'Picture Butte High School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6411'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a9a70b77-1aaa-53c8-bf10-2d3027dd19fe',
  'Dorothy Dalgliesh School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6412'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f11a354c-2c19-574a-a6a5-d29ff96c0ad6',
  'Chin Lakes Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6417'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '37ba13c5-9e4f-5697-8eaa-43e7a0b9c3d8',
  'Hofmann Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6418'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '950a7d51-5c39-5b2e-bba1-772ab356800c',
  'Rock Lake Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6419'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '487f69a1-2c8f-5540-9724-7298395ecf59',
  'Allenby Colony',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6420'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3fdc51bd-436c-5cf8-ac2e-574014a36ca3',
  'Gold Ridge Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6421'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0d05653d-b909-58b3-beff-f96d388d1269',
  'White Lake Colony School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6423'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2fa4da7a-0315-5dbd-8594-e1191144a6da',
  'Palliser Home Education School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 6427'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '419556bf-1f59-51f0-9574-e8479bced4d7',
  'Calgary Christian School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 9903'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b9edb019-0a91-5196-ba89-310aee5b680c',
  'Heritage Christian Academy',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 9906'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3d72b1e9-c92e-5ab1-bb7f-6f0c948f21ea',
  'Menno Simons Christian School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 9936'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dccaa4d5-1f82-576d-a088-9a8616b3f122',
  'Calgary Islamic School, Akram Jomaa Campus',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 9969'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd06cdc65-5c35-51a2-8fc7-ddbafb5e7e19',
  'Trinity Christian School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 9973'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e7f1eac6-d628-51b6-8ee4-c1a71001320d',
  'Calgary Christian High School',
  'ca864781-e87b-5c64-8af7-8639b7228e48',
  'free',
  'Alberta Public school. Authority: The Palliser School Division. Code: 9978'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5b657f2a-5807-534d-b173-6a99a1692320',
  'Gateway Academy Valleyview',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 1157'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '45182ca2-b3ac-505a-90f8-6bd65ed3f78f',
  'Fox Creek School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 1202'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'eaf7ea8a-dc24-5b79-8c7e-c42949ea01bc',
  'Hillside Junior Senior High School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 1206'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9f7f0e18-b2e5-56e5-801c-10ffb04b9c59',
  'Harry Gray Elementary School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 1207'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2769d2e1-8e60-5693-a5af-62112c0fb758',
  'Oscar Adolphson Primary School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 1208'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6484f5cb-b081-50ed-8215-0714bb1cef1c',
  'Valleyview Ranches Colony School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 1210'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '866cca6f-21b5-574b-8a5e-5d44ab0b626d',
  'Twilight Colony School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 1211'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bb2f3406-d2cf-5c8d-a783-5254b3943db5',
  'Gateway Academy Fox Creek',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 1389'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '95d21730-950d-50f5-a15e-4d7c9629d03d',
  'Gateway Academy Onoway',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 1551'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd433e363-b663-5bda-a9c8-96ad6e92e3a7',
  'Gateway Academy Whitecourt',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 1552'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5863d760-f546-5b69-800a-255b47f63fd2',
  'Homeland Colony School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 1960'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bf20b99d-12ed-5833-9bc6-b03084a6f49a',
  'Darwell School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 2103'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5e8f4837-d9f9-51f5-9e3c-42a5a5f5ca0f',
  'Mayerthorpe Junior Senior High School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 2104'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '00b4004d-f168-57d0-b49d-49b24ed7d43d',
  'Onoway Junior Senior High School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 2105'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5b4ca474-fe79-5dfa-b119-a9b4f4f6e7bf',
  'Rich Valley School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 2106'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f8238e84-aacd-502d-846c-f58a1763d62e',
  'Sangudo Community School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 2107'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4d35dfa9-08a2-5372-8b25-4eeccdff2765',
  'Hilltop High School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 2108'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '903043c7-3330-5f14-8457-ed9cb520900a',
  'Whitecourt Central Elementary School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 2109'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '03db0e2d-380d-586a-ba1c-f6db68232e3b',
  'Onoway Elementary School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 2110'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0d938ac8-ac63-5c3e-a060-e44174eba00f',
  'Pat Hardy Primary School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 2112'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4a7dfe20-0539-515d-b41e-10c0513b2995',
  'Elmer Elson Elementary School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 2113'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd68b5914-6917-5461-b270-1dbb6bd3935c',
  'Grasmere School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 2114'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8dc63cd8-04bc-5627-8cba-cea704f9eb47',
  'Percy Baxter Middle School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 2115'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f9fc6344-9c5a-50a9-9d30-06ca8837cc82',
  'Rochfort Bridge Colony School',
  '97f1277d-fa95-5d3c-8f98-9e62bdceefdf',
  'free',
  'Alberta Public school. Authority: The Northern Gateway School Division. Code: 2135'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'aa0f5236-30aa-57cd-80a2-476b3f22b21a',
  'Tofield Colony School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 0369'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '82bb0d06-5981-5020-9ce5-3549c3f339ca',
  'Northstar Outreach',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 1553'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '20b52142-e702-591e-a5b4-c52c76b7400a',
  'Rosalind Colony School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 1563'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8030d87f-99ed-555c-adfc-48fe03eeb47c',
  'Hartland Colony School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 1581'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '022f5963-ce88-5f08-99b7-c0e51531b993',
  'Lougheed Colony School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 1628'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a35198ea-4c77-59d8-a9cc-19e1f244757a',
  'Wavy Lake Colony School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 1953'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4c5fcf55-16eb-5bfc-b70a-da78c5ad7edc',
  'Iron Creek Colony School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 3503'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bd32021a-e01b-58b8-8f84-dfd12da725db',
  'Battle River Home Schools',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 3505'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '78b81678-e681-50e9-ac02-796932b1c5ae',
  'Ryley School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 3506'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4be5fae4-663b-5fc0-8286-e583cfa236c4',
  'Tofield School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 3508'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fc619883-6d1c-57a9-a6e7-d2aa8bc03a52',
  'C W Sears Elementary School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 3509'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '77ff57be-9285-5f6f-8f6e-c4353bb48aa9',
  'Viking School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 3510'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9757783d-4ba8-5c49-bfb7-97508d370248',
  'Viking Colony School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 3511'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c4ddb022-4c40-5bc4-8276-09f378c85384',
  'Holden Colony School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 3512'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '645630f2-6513-52ac-af37-04159a3e65dc',
  'Bashaw School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4502'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8fd679f5-17d2-50ec-b40e-937e0989b966',
  'Bawlf School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4503'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b38bded3-794d-584f-8bb2-1cabc8bc14d2',
  'Battle River Alternative Centre For Education (BRACE)',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4504'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '36c0041c-ea6b-5313-b104-7405e14bc56f',
  'Hay Lakes School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4507'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c2f8779a-8f6d-5530-814f-586564ee10d9',
  'New Norway School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4510'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd19811e3-894a-5056-b1a7-9613d2ce6212',
  'Round Hill School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4512'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a8a2c9d9-7513-504a-aaf3-fcf7c5891a22',
  'Sifton School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4513'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd6bb7566-1f02-56eb-be77-2edcdd3dd767',
  'Camrose Colony School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4515'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3463c7f8-a51e-593b-88e4-107b5e05974a',
  'Charlie Killam School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4541'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '87d5ff52-cf0f-5571-8bd7-1df9b50fb648',
  'Chester Ronning School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4542'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2ab1c1d0-0e14-525c-81e9-1e5aec29ef2d',
  'Jack Stuart School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4543'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8e06d189-dc71-5345-be3c-e93463c3967e',
  'Camrose Composite High School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4545'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a4e17df7-c11d-56b6-a211-71b3462b7866',
  'Sparling School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4549'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5eed2e18-b87d-5304-9d4c-43a464c4bc79',
  'Camrose Women''s Shelter',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4554'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4d5ab3c6-4434-5a6d-a9b6-b23b364c7d16',
  'Daysland School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4702'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b1925554-663e-5cb1-b46b-426c052685cb',
  'Forestburg School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4703'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7b151b9b-e918-5e16-9ad7-e53976775b3d',
  'Killam Public School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4707'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0456ba22-afee-53c9-a993-778f04c4624e',
  'Central High School Sedgewick',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4710'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fca374c1-0d99-567b-92d3-a33e1d4c40b3',
  'Southbend Colony School',
  'cd09eeb4-6c1a-55c2-9a64-258d092fa3c1',
  'free',
  'Alberta Public school. Authority: The Battle River School Division. Code: 4713'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '01bc79d9-54e9-5790-b2f7-a9130b5438ac',
  'Greystone Centennial Middle School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 1267'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8e46010a-1538-5c5d-b149-6b540372f2e5',
  'Athabasca Delta Community School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 1810'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '274d0791-abc7-5359-94c7-39f1b42b4223',
  'Prescott Learning Centre',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 1957'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '92d1e928-a90a-54fb-824d-16713efdf5f1',
  'Copperhaven School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2181'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0e0a4d8c-f236-5e5d-a58b-43f163251e05',
  'Duffield School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2204'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4b5160d1-af06-5be1-9035-13a06b0202d0',
  'Entwistle School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2205'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7c03cbea-6421-5800-9044-899d5241d519',
  'Spruce Grove Composite High School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2208'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '058b970f-ac7a-5b7c-b178-389bd24c411a',
  'Memorial Composite High School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2209'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '16be2f58-d4ea-57ab-8675-a6db6ef6a1ae',
  'Westview School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2210'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f0341649-b61d-5a1c-8c68-659b920c4f74',
  'High Park School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2211'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '14cdbcfc-f89b-55f0-93a3-e164273bb9fd',
  'Wabamun School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2212'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3f7115e6-9fbe-5e02-a14c-dba01576f3b6',
  'Tomahawk School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2214'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9b03a509-eabb-5bce-8d4e-5ab1ff67030e',
  'Parkland Village School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2217'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4763e0ac-c7bd-5f87-bae7-47e09ff2a3f8',
  'Brookwood School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2219'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'efd9f698-63db-5038-bc89-2791be53520f',
  'Ecole Meridian Heights School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2220'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8bebe449-f672-511e-8f03-b1402417e689',
  'Woodhaven Middle School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2221'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ede6e413-77b3-5ee8-897d-b4a0dbb0970f',
  'Millgrove School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2224'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f9942293-9f50-53f6-8075-b73c43e619b9',
  'Forest Green School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2225'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '86685af6-8261-5956-9ab1-2b9f3d6f4d0c',
  'Muir Lake School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2226'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '68c3777f-3e3c-5e75-b645-2ddcfa65087b',
  'Blueberry School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2227'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '966af5b6-5ef8-5b7e-8942-810252cc95bd',
  'Ecole Broxton Park School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2228'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'aaba0994-ad46-5f71-90ca-00e078398ab2',
  'Graminia School',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2229'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5f4df5bd-7dbd-5f58-b4ed-8c4ae0f9bcf0',
  'Connections for Learning',
  '0320b3bc-6356-5a18-85a2-80edb3780a40',
  'free',
  'Alberta Public school. Authority: The Parkland School Division. Code: 2235'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3fcabdf9-0fe2-5217-891d-162dfa90a0e1',
  'Centre High',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 0017'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '98c1d930-6903-511d-9a18-ca0ee4b756ef',
  'The Academy at King Edward',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 0018'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6dacd839-dd73-533a-9a9a-1bc59c9c418d',
  'Transitions at the Y',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 0325'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e5d63b8b-222b-5a5d-8337-d78a02c31089',
  'Argyll Home School Centre',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 0349'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3c07d0bc-8b78-5238-bf5d-ad6286877b04',
  'Learning Store on Whyte',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 0386'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '46d87c55-d9bf-567e-8620-c6642e9ad0fe',
  'Amiskwaciy Academy',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 0484'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0ef58335-446f-53f7-8dba-95f1f60057d9',
  'Jackson Heights Elementary',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1003'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c2021d43-de16-5801-97eb-d7953e5bf0c3',
  'George P. Nicholson School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1004'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2bd7c71a-29e1-599e-af8c-ab7f1c4587c6',
  'Learning Store West Edmonton',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1022'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0fd1d64e-981c-5c78-87f2-b01c3c3ad8dd',
  'Edmonton Christian Northeast School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1282'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f9d14f34-d158-5821-b272-8343fd61d186',
  'Edmonton Christian West School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1283'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3d38c0b7-5635-5370-9c3d-ff7439049027',
  'Lillian Osborne High School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1344'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '54f7d97f-35c9-51e0-8f0d-d8782df52cb6',
  'Johnny Bright School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1455'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '243d3496-a396-5b75-95bf-dc9e4173c439',
  'Dr. Donald Massey School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1456'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4fde1261-2627-586c-bdde-5f2f261675b0',
  'Florence Hallock School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1457'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd4d666bc-c9b6-5af5-8118-7ce210aed53f',
  'A. Blair McPherson School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1458'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3aaa8d34-154b-5c50-835d-5f6cd81d8c1a',
  'Elizabeth Finch School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1459'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd04a482d-62d1-5a7b-9139-00666346db1a',
  'Esther Starkman School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1460'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '043c690b-8100-51b8-80bd-369f71363c40',
  'Bessie Nichols School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1577'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7f3a7ff9-60ef-5d37-b18e-24616572ace9',
  'Michael Strembitsky School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1578'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b9d5593d-b0f6-5b08-b4f4-774c4088b956',
  'Constable Daniel Woodall School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1924'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '40494593-bf38-5fd5-bc68-fd29499b197b',
  'Kim Hung School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1925'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '39f37076-439e-5b49-83fa-b9c8fb9c12ba',
  'Dr. Lila Fahlman School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1926'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f4613c9b-283c-51ac-bcb7-c0889eb876bd',
  'Jan Reimer School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1927'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2673dbe8-6044-5c8b-a6c1-15dfe47bae3a',
  'Svend Hansen School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1928'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7665c70e-e686-56f0-903d-ad26d2d30367',
  'Shauna May Seneca School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1929'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ee1c5995-62e1-5795-a129-6f6c807b710f',
  'David Thomas King School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1930'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9180b08d-2fb5-5a27-bd3b-a0477ae7b2be',
  'Hilwie Hamdon School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1931'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ecbb1f2c-c935-575c-9a0f-1e262fe276cc',
  'Michael Phair School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1933'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '19ff1685-6e9b-57c3-bce7-abb98bc682f2',
  'Dr. Margaret-Ann Armour School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1934'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7557e202-955e-59e3-a30d-0dd043808288',
  'Roberta MacAdams School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1935'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '204cae14-dd0d-51ec-918e-fcd8b70a6e6b',
  'Nellie Carlson School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1936'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b9389733-0c90-5e80-b318-bced6f4d89ea',
  'Donald R. Getty School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1950'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5c9a2f68-5b79-5f77-b86c-1af224f3d2a8',
  'Ivor Dent School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 1951'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0457e64e-3301-5220-aa7f-6ce3e1532f99',
  'Thelma Chalifoux School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 2169'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9a652c6a-2ceb-50bf-91b8-1060ea93878e',
  'Soraya Hafez School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 2172'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '19b6f3a6-e95c-5181-9d73-f0c6a2b4853a',
  'Dr. Anne Anderson School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 2249'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '768eb1d5-ee69-5cbf-b0ee-ed2f0e85fc9c',
  'Alex Janvier School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 2268'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '269de920-0f61-5ec9-8607-4322b837b7be',
  'Aleda Patterson School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 2269'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5ad4f86f-099a-5867-98e2-701a4264c852',
  'Garth Worthington School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 2275'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '62606b97-4d69-54ca-ae6d-8930b43d574d',
  'Joey Moss School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 2433'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '57964f07-ef6d-5177-9945-8b628c52af19',
  'Elder Dr. Francis Whiskeyjack School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 2566'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5ec5df1b-3739-5add-ba4c-33fa5814a8b3',
  'Vimy Ridge',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7050'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bc0f7636-408d-5435-8eca-6457f89ce436',
  'Eastglen School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7051'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1e09edb0-9d9b-5728-a739-85581d0aee40',
  'Queen Elizabeth School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7052'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '62c4e655-1217-52e2-8c5c-2ef337dfcad8',
  'Ross Sheppard School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7053'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '03ef45df-2ccf-599e-a7e4-ea7c1d4ed4e3',
  'Strathcona School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7054'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '24b2c86e-93cd-5f03-ae9c-2d13e2ffc061',
  'Victoria School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7055'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9f757124-b0ed-510c-b7db-321f86c135ad',
  'W P Wagner School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7057'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd06db145-356c-5853-bab3-1ed2a501df94',
  'McNally School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7058'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd50db2bd-ec7a-53d7-9a1d-4d79a2f6c457',
  'Harry Ainlay School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7059'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '47eeabfa-3224-5b1b-a727-371a151e1599',
  'M. E. LaZerte School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7063'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b340022a-a582-59c7-9acb-526fe29bc18a',
  'Old Scona School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7066'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fd480bca-0736-5e28-a0e6-f81035bfb3b1',
  'Jasper Place School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7071'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3d8db676-60cf-5136-ba16-1fa62980ae02',
  'J Percy Page School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7075'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0a4ead51-933d-50cc-8913-a195e475954a',
  'Metro Continuing Education',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7090'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b9941bd3-6f99-5ab7-b46d-22a112eca011',
  'Abbott School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7100'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e1401ce1-8dc3-5c3e-94b8-4d9c4a2513fa',
  'Athlone School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7104'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6c40a225-c3e7-52bc-a09b-e7af29c3b0d9',
  'Beacon Heights School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7106'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'be866bec-20f4-5337-879f-d9206ed41a9e',
  'Belgravia School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7107'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4032eaec-40cc-5a2a-a63d-895191e47a90',
  'Belvedere School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7109'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '13f74724-be10-55fd-88df-94f90f0ec437',
  'Calder School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7113'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3078faf6-ba67-56a6-b626-a4d6ebf9d461',
  'Coronation School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7115'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '38f297ae-ffe6-5bef-b739-e9a15638b467',
  'Delton School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7118'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b8d3d380-c2ac-5e9e-91b9-0e5fc7b74357',
  'Dovercourt School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7121'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e297874c-eb71-5b16-9199-786a8170f5ff',
  'Forest Heights School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7123'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6970b200-407c-5945-b77a-d72f2e1f879a',
  'Glenora School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7126'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8dda269e-e9d8-55cb-b036-0e5bf0a2723a',
  'Gold Bar School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7127'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd36153a6-dd3e-55b4-9f07-e93d26ffa9a4',
  'Grandview Heights School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7128'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c6a28cce-d93f-5394-937f-a5e010eda789',
  'Grovenor School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7129'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e448bb7f-84e5-5f84-a5ed-d05685560639',
  'Hazeldean School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7132'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0e8e313d-3c0b-5961-8099-7e9727d1f528',
  'Inglewood School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7136'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1d485fcb-942e-5708-9dfd-fdc0fbe41fd8',
  'Kensington School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7137'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2b5b3d31-d022-52a7-850e-02767bc318b4',
  'Kildare School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7138'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5bcb4a11-74a7-588c-9652-caf1794d5001',
  'Lauderdale School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7141'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '15b0f24a-0f5e-5996-9b79-806ad4f8bbe1',
  'McArthur School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7143'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '59d05088-e33d-5ac6-83fb-0bff187f819e',
  'Brookside School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7146'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '89e366e7-7f05-5822-ad40-90c2a5bded65',
  'Mee-Yah-Noh School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7149'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4b1dbbd1-1726-5f8f-9148-50e4d690b4fd',
  'Mill Creek School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7150'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1545858e-a3a4-5982-9ddc-327fd5b63e20',
  'Norwood School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7156'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bf811046-6656-5248-82a6-5ffa8ce43a01',
  'awâsis waciston School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7161'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a3e06c6f-97ef-5027-a5ce-cd39127e6122',
  'Queen Alexandra School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7164'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9eafa6a1-ac86-522b-9870-61345ee7f196',
  'Riverdale School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7168'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3b4d6926-6bab-5574-aae5-077443659ec0',
  'Rutherford School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7170'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7d5a6c2a-2695-5ce5-b7a8-01f793cd1e08',
  'Scott Robertson School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7171'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2d0713a8-0850-562e-86d7-e9c36e6d2754',
  'Patricia Heights School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7176'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c454f8b2-5b2e-50b5-955b-24cbd24bdb8a',
  'Virginia Park School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7177'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ea676542-6652-5573-b40b-4e6943e2cc95',
  'Greenfield School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7178'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1b2380cd-e884-5b20-987a-e2756975794b',
  'Lansdowne School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7180'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '587a17b7-f723-5acc-acd4-352fb222f9fe',
  'Windsor Park School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7182'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'eb19414f-c5eb-59cd-8115-c3d5fcbe36f3',
  'Glengarry School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7184'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '136d9cc4-a7be-5ece-871d-ef01d309f253',
  'Lendrum School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7185'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b78e9ee5-b482-5d87-96e5-756bba1323db',
  'Malmo School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7186'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd8681e4c-5e4a-5119-a639-ebb3b97b78a4',
  'Princeton School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7187'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '259b6c9c-81a0-59b8-bfe0-74c00b7f73e2',
  'J A Fife School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7188'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f8e42119-f13e-594e-870b-b42655256e11',
  'Waverley School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7189'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c856e6be-c99a-5e3e-a1f8-19cf53378f5a',
  'Northmount School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7191'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0ef997b8-ba05-54c1-b71d-45919a1cd1e4',
  'Clara Tyner School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7193'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bf754d77-9ad8-50b3-a95c-b92f81dcdf0e',
  'Delwood School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7194'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a117e2ac-6fba-54ed-9937-48bf0ad9e1de',
  'McKee School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7195'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '583aa277-2a85-5ea2-bd9e-e3df5bea000f',
  'Westbrook School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7197'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '032011fb-44e3-5eab-a430-4b33151abb64',
  'York School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7198'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '73df9ad7-f7ad-5446-9962-962dc7f64b83',
  'McLeod School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7200'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3063975b-86d4-5390-bd4f-05e85fe22426',
  'Richard Secord School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7201'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ab2b0796-0923-51de-a1f0-85bbf13c62ab',
  'Elmwood School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7204'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7001bcb3-a777-54e1-b47b-2aea6487a5d3',
  'James Gibbons School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7207'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '18eac2d8-8f2c-5d44-89c6-74fd9ad136ca',
  'Lynnwood School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7208'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ed259cc8-423f-53cf-8ca7-71b6fbafbe0a',
  'Mayfield School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7209'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '63a4f1ff-1a1d-51f3-80c1-93db96d82b30',
  'Meadowlark School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7210'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd1774ce0-bad7-506d-9328-3e27720791fb',
  'Rio Terrace Elementary School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7211'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '994ee07f-fc6b-57d2-8abe-e5b046b8e718',
  'Youngstown School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7213'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cbf26a73-0127-5caa-b7da-705a01fc75fe',
  'John Barnett School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7214'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7f33b6f8-f149-57ed-b7de-7d97899446cb',
  'Evansdale School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7215'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '806c504c-1e3d-5a6f-a771-2ac53fd7d0fa',
  'Thorncliffe School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7216'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ebadfe39-d712-5cd6-82e2-f760632b1134',
  'Duggan School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7218'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f107c3e4-580e-56fe-aa98-875ad14bb4b6',
  'Grace Martin School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7220'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e2fa5e3e-7cc6-58ca-babf-d92c1f26b21a',
  'Malcolm Tweddle School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7223'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0b6322d8-99b6-53c3-85d4-0cbc3228dcc5',
  'Lee Ridge School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7224'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd0c17cdd-f929-5822-88d4-f75d430fdf3a',
  'Caernarvon School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7225'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd7e0e6aa-f466-5444-a95f-f641a77e172b',
  'Brander Gardens School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7226'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9e000e08-08d3-5fbc-a988-147fba42da7f',
  'Belmont School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7228'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cd2d4351-39f3-5991-baa5-16e9b28ed165',
  'Overlanders School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7229'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c06e1300-338e-5484-b1ca-4361d778cd11',
  'Rideau Park School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7232'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a6962290-ed2a-5d8e-8a6e-6ae5a5081025',
  'Ekota School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7233'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '23a6e78d-0acf-5809-b6a5-7526a65058b2',
  'Aldergrove School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7234'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b2a09202-1377-5dd6-897f-aab0b5039877',
  'Satoo School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7235'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '851be971-4ddc-53ae-a08e-02209f266efb',
  'Belmead School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7236'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5fb0da7f-f989-59db-bf86-c6e056a045c2',
  'Callingwood Elementary School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7237'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4a358a83-eec5-5973-8249-e81b891bac75',
  'Sifton School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7238'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '58e2a9bd-d96e-5de8-9180-f85f352db5bc',
  'Kameyosek School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7239'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9c0da08d-95ce-5b2b-8bb3-b4cf037cd497',
  'Homesteader School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7240'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '865433c3-f56a-5e97-b66a-b7129df9f641',
  'Steinhauer School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7241'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'eaba623f-21a9-52fb-9f01-0556d772f6d6',
  'Lorelei School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7242'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1804b1ea-7a3f-574a-a252-af4d070e6713',
  'Sweet Grass School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7243'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '836731f7-99d1-5ad6-809b-9555e164f911',
  'Dunluce School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7246'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '74b481ca-fe56-5b77-beda-d3cd51ceb9c2',
  'Baturyn School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7247'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '75639af6-9ea1-56f0-be0d-c55dae33be9f',
  'Ormsby School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7248'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b8fb108f-5048-5a7b-954c-678cd444f9d3',
  'Meyonohk School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7249'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e138a826-e37c-5545-86e7-0520f7098f60',
  'Greenview School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7250'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '86a343e4-ba85-54ac-813b-0e42003a8a7c',
  'Sakaw School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7251'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b4a538cb-13c9-5825-bf0f-7f4b22f07510',
  'Bannerman School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7253'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '17f67eb4-fbeb-517e-ad9f-832b96bcf163',
  'Keheewin School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7254'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'eaa9f13d-5389-5750-8621-7938b7a37078',
  'Hillview School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7255'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fd0b3860-3697-55a4-88cc-7fb378b31a93',
  'Meyokumin School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7257'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '71325b3b-fd74-5df4-884d-b983bc5233a3',
  'Pollard Meadows School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7258'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6d6f97c8-b471-5ec6-b625-b6bb921896b5',
  'Menisa School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7259'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4beba0b6-9805-5f88-81cd-d298b27a5851',
  'Centennial School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7260'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0367bfa0-b9c4-5df0-8bc1-016a9519c235',
  'Kirkness School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7262'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4b518771-de35-5156-8163-710bb6c4d200',
  'Crawford Plains School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7263'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'faaa4d16-0ef5-5b1b-8820-d8c44b89c870',
  'Daly Grove School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7264'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '80e8f81b-aa34-556e-b597-941bb3983659',
  'Weinlos School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7265'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3105bf5d-fd85-528a-8fd8-36e652b3d4e9',
  'LaPerle School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7267'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b237c03a-4215-56dd-af4b-132e44810d20',
  'Lymburn School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7269'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '77881aec-847d-59cd-8d53-24d681c9a0f1',
  'Tipaskan School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7270'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '848296eb-9eca-5a5b-a60c-bbd1c36cb22d',
  'Fraser School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7273'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5e89bf1b-67e7-5640-9808-de3940a5fd00',
  'Minchau School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7274'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4c43454b-7179-5f57-bef2-b9698855fd07',
  'Julia Kiniski School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7275'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'df9be38b-acea-5bb7-80ee-47b014928507',
  'Bisset School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7276'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7bcae4fe-3eca-50b7-a608-33ddd5650a2e',
  'Lago Lindo School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7277'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a5108f79-bd81-5894-805f-7fcc988c131b',
  'Earl Buxton School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7278'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0efcdca1-435d-5e8d-92aa-474e7b59fe0f',
  'George H Luck School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7279'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4c9bcdc5-3168-559f-8e2d-221335f26974',
  'Velma E. Baker School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7280'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ef8f1df7-a732-50dd-97c2-7ac1952f1470',
  'Michael A Kostek Elementary School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7281'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e7284495-89b7-5766-a60a-ae31884c029d',
  'Allendale School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7500'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c28e0363-3a59-5d2d-a586-d76003f51241',
  'Avonmore School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7501'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e39423c9-ab8b-5044-b190-6e5db47863af',
  'Balwin School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7502'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '87e072a3-1da6-51c0-a241-aa917b38b1de',
  'Crestwood School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7503'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '122cae1e-ee37-504c-8312-419d0595dda6',
  'Brightview School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7504'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5f68850d-5f77-544a-9992-aeb0b5a916e2',
  'Donnan School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7505'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0823e1d7-e9fe-598e-a262-dcaefd5d7548',
  'Garneau School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7509'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '16f4100b-6b12-5310-94d5-b8522d9deac0',
  'Hardisty School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7512'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e28b0fc7-ea35-516e-95d9-3646167eff25',
  'Highlands School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7513'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8dd9538b-bd7c-5274-9f8c-504a4e2a1d46',
  'Holyrood School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7514'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '65b15c18-1923-584e-aa1c-95352d27d63f',
  'Killarney School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7516'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ae55ad5f-c50e-5283-a28f-ecb9da4094dc',
  'King Edward School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7517'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '48d80d9e-3b0f-5a5e-a78c-30b2bd7aa1c7',
  'Laurier Heights School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7518'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '70398ee5-c28f-5d56-8a0b-879f77b8cffa',
  'John A. McDougall School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7521'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '04708d2c-59b5-502c-86b6-73a67d21e38a',
  'D S MacKenzie School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7522'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c6e57d69-bb78-5883-aac9-e79ebddabdd4',
  'McKernan School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7523'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c15ae698-1f95-56b8-8bf0-fb3cbbd72e28',
  'Mount Pleasant School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7524'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4644357f-86fc-5931-b8a4-b8d7b4c31181',
  'Wîhkwêntôwin School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7527'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7d0ff471-6b27-5759-b411-f9b73f1664cb',
  'Ottewell School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7528'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c896618f-d202-55bc-8050-714fa61f1bb3',
  'Parkallen School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7529'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4a10081e-9357-5d22-81a4-433d170951d1',
  'Parkview School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7531'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '43a46c78-b687-59b6-8e6f-7b1cb07c0459',
  'Steele Heights School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7532'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7c537215-da13-58fe-b9e8-2be1b403fe0e',
  'Londonderry School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7534'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9dc81598-adc6-51be-9f8d-f07858cf8d2d',
  'Rosslyn School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7535'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ffa1671e-673e-5606-94f8-ed8028c42861',
  'Spruce Avenue School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7537'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6ebf93e2-1441-508b-b6f0-8e17882c1f82',
  'Riverbend School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7538'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ae4fee8c-785e-5d8c-b8f8-7f73b44bed08',
  'Westglen School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7542'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a4f8d564-e412-5a69-90f6-3fdcd83ad194',
  'Westminster School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7543'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b1a2b5df-310d-5b38-96ee-8c5f4f31bae1',
  'Westmount School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7544'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '17a55bb4-4883-5b79-ba43-ea43b20eb5d1',
  'Kenilworth School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7546'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6c65812e-83a3-5e0a-ba35-2061181815fe',
  'Avalon Junior School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7550'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5fec50e0-b374-513e-be81-8938d53cbc2e',
  'Britannia School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7551'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '71bf1659-c9d3-545d-ad6c-63d2ec7650d4',
  'Hillcrest School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7552'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '72fa37b1-9774-582f-9fd7-aa7307a8c6c7',
  'Stratford Elementary/Junior High School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7553'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8dfa814e-b0dd-5cdf-9dd0-71b2ab787210',
  'Vernon Barford School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7557'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd5f070cf-721f-5bc9-b2ee-b96d828e2a67',
  'Dickinsfield School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7559'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '892719d5-4ebc-5cac-afba-0d65a89e8921',
  'Edith Rogers School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7561'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ae0134c7-79c4-51f6-b699-a86fb266abda',
  'kisêwâtisiwin School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7563'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8f689fad-e9a4-5b3a-b725-2d4f8df97656',
  'Ellerslie Campus',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7565'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7f136220-cd4e-50f5-a731-41fb2e552fe7',
  'Horse Hill School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7567'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ac580158-8de5-54d1-8a96-4365dc2ff7cd',
  'Winterburn School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7569'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3b07a8f2-2322-534d-a654-059af0b871e7',
  'T D Baker School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7570'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f58cf278-0537-5511-aa25-77d6c2e5c5c5',
  'S Bruce Smith School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7571'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '00454375-0261-5552-b0e7-79b21545b6a4',
  'Mary Butterworth School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7572'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c5e0b651-ae3f-5091-a214-83c0a67d36c4',
  'John D Bracco School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7573'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cf6a0775-84ef-5687-8402-dca81c8aae24',
  'Kate Chegwin School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7574'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6157a39e-b84b-50bb-b26c-2a7c14bbd079',
  'Major General Griesbach School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7575'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f50b5038-0e72-5ce0-bebb-b0e3560e9f14',
  'Hospital School Campuses',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7701'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6312c0c5-94a3-5f3a-bd37-7e982e878e3b',
  'L Y Cairns School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7702'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1263db99-e1db-55e0-ad6a-ac448b9df443',
  'Braemar School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7704'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5953da34-3991-553b-889d-93db387c22c9',
  'Institutional Services Schools',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7706'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0940ac18-5bd0-58d4-adc5-9647516de580',
  'Aspen Program',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7707'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '07112513-90b5-5a59-934e-bc92baa54320',
  'Learning Store at Londonderry',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7722'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3c6722fe-71e9-5420-9174-015681bc5d5d',
  'Learning Store at Blue Quill',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7724'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9492b9c7-c49e-5570-9069-6395564501b8',
  'Rosecrest School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7729'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd4692f3f-c0d9-5b2b-903f-5f93e84ccadf',
  'Alberta School for the Deaf',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7730'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '18359178-de4c-5a6f-9626-defea6701bbf',
  'Tevie Miller Heritage School Program',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7772'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1d4b3037-e0dc-50a2-acb2-347b0c894c30',
  'Edmonton Christian High School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7905'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fdd9f44a-d166-509b-8ae8-784027a8ea68',
  'Millwoods Christian School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7909'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '934d239a-1e94-573d-8972-426e8af2dedd',
  'Talmud Torah School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7911'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2342bfc1-5e0e-562a-af31-52ef78bfea29',
  'Meadowlark Christian School',
  '38ee3f2c-ca29-5b19-a62c-c6ba3aa6e902',
  'free',
  'Alberta Public school. Authority: The Edmonton School Division. Code: 7931'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c0572e83-bbfb-5e36-90dd-4e105b6372b8',
  'Midsun School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 0348'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ccf68995-f438-5ec3-a141-7de9b2ad9078',
  'The Hamptons School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 0387'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7babf7b2-9e4e-56fe-b353-d5f20608fe7c',
  'Hidden Valley School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 0535'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0c6e7175-289d-5554-a955-a4d72f5e15f0',
  'Crossing Park School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 0536'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c0148aa1-12ec-5146-a6fd-90b9a922df7d',
  'Battalion Park School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 0537'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '09a947b1-917c-5f7a-86fe-8376aaab4b24',
  'Monterey Park School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 0538'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c68e2980-0df3-5930-843d-2ab833d4a898',
  'Douglasdale School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 0596'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '52b26f9f-ea51-52d0-8b1a-43b13346ac0f',
  'Scenic Acres School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 0597'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1badcb4f-6e97-5e6e-8bf4-3c7dc54145f7',
  'Coventry Hills School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1038'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '32b829b3-cb5e-58f2-8dc7-6c2717e40eab',
  'Colonel Sanders School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1053'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6a12f2c9-daf0-5615-8c70-a7406c91d72e',
  'Piitoayis Family School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1054'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c9080d8d-f427-59ad-a8b5-d415cc1d3597',
  'CBe-learn',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1064'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '96d6d983-55fd-5158-9417-e774474861b3',
  'Valley Creek School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1098'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b8e8360f-1861-5920-9b20-676d675a0ef5',
  'Somerset School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1099'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '230d2f85-ff83-5b2c-816f-ec865349b13c',
  'Discovering Choices II',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1161'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '692c26d7-c2a0-52b1-ad97-ae9447b2c2a2',
  'Centennial High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1224'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'afb3bdef-02ef-52cf-afba-3f202bc6894b',
  'Start Outreach',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1232'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4484740e-091c-5824-9d8e-140ebf997733',
  'Westbrook Outreach',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1260'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bb0fc84f-d0df-5fa7-95db-2d4324f9ae9e',
  'Arbour Lake Middle School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1330'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5b3eeb10-3e5a-5aec-822f-4f1a1b58492d',
  'Chaparral School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1331'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '183131e8-35f8-5d4a-86d0-74ec6ba35a37',
  'Citadel Park School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1332'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '83a7d384-d8fd-5302-8207-1d81fe1eaefd',
  'Mountain Park School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1333'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bd1431ce-c058-51ac-a3e9-db358408e431',
  'Radisson Park School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1334'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3567cb4b-19d0-595f-b54a-aa9886d26fc3',
  'Tuscany School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1335'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0c264a16-9bb3-522e-8dff-1a01ba90486a',
  'Taradale School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1450'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6e2bc398-901e-5206-ab96-bb8de4feff39',
  'Samuel W. Shaw School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1451'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ac1b4e8e-d129-537a-bf54-68e07b4a9e09',
  'Panorama Hills School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1452'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '70e43234-eeb4-5a47-a38b-582cfffeb9e3',
  'McKenzie Towne School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1463'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a7277180-db90-5fdc-9188-70e0d56c4ec3',
  'Bridlewood School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1498'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd5c6a6ac-57e9-5819-a8c6-a5063a341ff7',
  'Cranston School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1499'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ad7114b0-3693-5934-a7ee-a47014550114',
  'Evergreen School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1500'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b9f4c83d-850f-59a7-b8f8-4e7ff1f54339',
  'Royal Oak School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1519'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1e39ae9e-e339-5ecd-af61-c76d81b379b6',
  'Saddle Ridge School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1520'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '77476555-06c9-50e3-bf6b-8bd05f9d48c7',
  'West Springs School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1521'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e3588452-d5a3-5d20-9d42-8ef2da0eb623',
  'All Boys Program',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1579'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f776bc3e-7d01-5977-a08c-4bd254960516',
  'Nose Creek School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1674'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8bbeca29-21ad-5cd9-b312-e5e19b726b3a',
  'Captain Nichola Goddard School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1676'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a1c1a311-858f-5d8c-a826-b1b2263d6da7',
  'Ted Harrison School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1677'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9f0c2eaf-0764-5248-88c1-26a27464b3ab',
  'Twelve Mile Coulee School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1678'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b4f4287d-902e-5494-bbdd-959a2cb9e84d',
  'Robert Thirsk High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1679'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '509efe0a-6a8a-5e19-9444-321e553d1aed',
  'Adolescent Day Treatment Program',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1749'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '704f8468-0a46-5604-b853-aafee7086b0c',
  'Nelson Mandela High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 1989'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fdc2b87c-a9d6-53b8-94a9-d55053ccae77',
  'Buffalo Rubbing Stone School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2029'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '693af43f-494e-575a-af79-8e70aa3a5ade',
  'Eric Harvie School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2031'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '63348936-cef5-503d-a616-f663580ae62e',
  'Dr. Roberta Bondar School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2054'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e965b5a7-7936-5edf-bffa-e3e750a803bf',
  'McKenzie Highlands School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2055'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dc2882fc-275d-51a3-bf22-64af8e14d3a1',
  'Hugh A. Bennett School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2056'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0bd8ec42-c3a2-51e2-91b8-f8ebb9dcfbf9',
  'William D. Pratt School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2067'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a1a198f7-6a59-5f6b-9f62-9bc3bdd4ef7e',
  'Peter Lougheed School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2068'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a2d1a2b2-c9cb-5e54-af06-8b2bfc5f2679',
  'Marshall Springs School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2069'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ed6b731d-53f3-5cfa-92a6-9cf490f355f5',
  'Dr. Martha Cohen School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2070'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b43b2139-4e70-569b-9cfd-d0b672ae960c',
  'New Brighton School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2072'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '150ad783-eb53-5905-a0b1-839cadc233c7',
  'Dr. George Stanley School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2084'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6170e4a2-7cc7-5cff-9dba-fd587624259c',
  'Auburn Bay School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2085'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3c64481b-8efd-57a3-9074-ee134e2ec8b8',
  'Copperfield School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2086'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b690ed2e-f042-5532-b281-ae5bc3d507a8',
  'West Ridge School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2087'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3236bc47-4a5e-52b7-810c-3903949f3480',
  'Kenneth D. Taylor School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2088'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '36355069-74e9-5403-8bb7-8b54fe8a950e',
  'Niitsitapi Learning Centre',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2123'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '01dc095c-6485-5448-ad02-13d1bf92ac9f',
  'Manmeet Singh Bhullar School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2145'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '56eaf950-5f2c-55a5-8084-e24521ecb6a6',
  'Ron Southern School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2146'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ef1efd7f-d3be-586e-9b91-28da2fec5543',
  'Griffith Woods School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2147'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1f816f40-070c-5345-bc3e-f65b8edf21b3',
  'Joane Cardinal-Schubert High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2180'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0f6938e8-8391-589a-83ba-775797cdd74f',
  'Dr. Freda Miller School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2280'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '666a27ce-0b39-529f-9868-6bb0ed09539e',
  'Sibylla Kiddle School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2281'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8bded985-3753-5f11-a6bc-da40cbfd1eb0',
  'Northern Lights School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2282'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd7fd3c6c-9d76-5fda-9d3f-0efc1c16127a',
  'Mahogany School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2425'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '31fad45a-1207-588f-ac35-e91fe215c17f',
  'Lakeshore School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2426'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '54a49de5-4b96-5359-9799-31ac07e25dc8',
  'Bayside School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2427'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2bcb2177-69fd-5f63-ab61-6a514c91a28d',
  'Prairie Sky School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2428'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'af5cf413-2175-5a17-b7da-2d27e71b9716',
  'North Trail High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 2475'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0c42a1cf-8733-5d99-a847-4454397d4d7a',
  'Children''s Village School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9014'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3298301e-58d4-5f89-b473-d01f16b252ca',
  'William Roper Hull School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9033'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a55e1e90-269c-525f-a9c2-a8373727705d',
  'Wood''s Homes School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9035'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0407f014-3aa0-5ada-aeff-cc30358bad00',
  'Emily Follensbee School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9036'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '587fc647-8a0e-5ad5-8139-ff835e2c7c33',
  'Christine Meikle School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9037'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6352c592-6538-5584-b010-1b2867aea795',
  'Richmond School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9100'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '88e6e740-ab99-52fb-a7d0-adc1efb7fc2d',
  'Alex Ferguson School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9101'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cb88f051-6a33-5f33-b8ee-9121ada0a72a',
  'Jennie Elliott School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9103'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'eb1f5d05-6c6e-59f0-b7b7-7af2ecaee899',
  'Killarney School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9104'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7db96431-e2f6-5fbd-b0a1-6fa90faaf81f',
  'Altadore School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9109'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '023f0b10-fd84-5719-926e-f1b9fc53b233',
  'Belvedere Parkway School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9110'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4d269702-c53a-5ec6-a9e9-872c590a62ec',
  'Bowcroft School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9111'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1fea3363-9f35-5892-b9cc-ab9744657f41',
  'Connaught School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9114'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '049b2276-b9c0-52b4-ac37-dac08368509f',
  'Earl Grey School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9118'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5a3da050-1115-5043-a053-d9123a9c1e5e',
  'Elbow Park School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9119'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2bdfe72b-2985-5317-b6c2-c7529e0f0be3',
  'Glamorgan School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9121'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6e6a2b54-5c69-5192-b96a-ae466ee24288',
  'Glenbrook School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9122'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'df32a84a-d3ee-5da1-8d48-dc7915defc93',
  'Glenmeadows School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9123'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '370c7222-8640-54d2-ab98-a91e3b3da646',
  'Ramsay School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9130'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '251799be-4cb3-5e6e-a435-f8dba4299b21',
  'Terrace Road School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9138'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ee3c2c0d-c299-56ab-a3cc-e55e5e1bbd25',
  'Westgate School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9140'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7a864463-20f0-524f-80eb-b50c32dcb390',
  'Wildwood School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9141'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8666b432-583b-58f5-b77e-3020ca54b804',
  'William Reid School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9142'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6cc9c563-ed26-53e1-8d81-9027f5de1325',
  'Glendale School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9143'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bb3016b5-5f0c-586e-ac89-730e8e444c53',
  'Banff Trail School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9202'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8a50a17a-b1c2-599a-8e75-03261e6cc54b',
  'Belfast School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9203'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1f1db0e5-ec1e-5b91-a5dc-d60306ff813c',
  'Brentwood School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9204'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '456724df-ab21-50ff-b48a-ef40562c22da',
  'Briar Hill School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9205'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cb6f90b9-4982-547a-abae-fbde487dd2b3',
  'Buchanan School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9207'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '930ea8ee-dfc7-57b3-b273-6e2c28369502',
  'Cambrian Heights School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9208'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f233b0c3-2c1b-51e9-8d46-497c51b0c082',
  'Capitol Hill School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9209'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '663d54f9-6e87-516b-9bcd-cdcb5e8dc348',
  'Captain John Palliser School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9210'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4b8509e7-52b6-5bfe-9a2c-a260455f78ee',
  'Collingwood School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9212'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f144be28-9448-52b4-aaba-3de5c4768bc9',
  'Dr. E. W. Coffin School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9214'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '323cd3bf-ef44-5592-aebc-108e6b0879d8',
  'Highwood School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9217'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '36798ed7-57ac-59b8-8c54-8e5cf1d07af0',
  'Hillhurst School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9218'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f3f78344-fd55-5c5d-9714-5347f40d0ca1',
  'Huntington Hills School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9219'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5200461e-236d-599c-a339-d45252eba968',
  'Mayland Heights School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9223'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5d5ab315-163a-5fdc-85b7-1a41dbf603a2',
  'Mount View School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9224'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '08ade2b1-26e8-5826-80f3-78f5bbeda2ed',
  'North Haven School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9225'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bdcd19e0-86ac-57a3-882b-3dad0a44baa5',
  'Queen Elizabeth School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9227'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '235082a0-7948-57d5-a984-bfdfaaff8ad1',
  'Rosemont School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9231'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a9ad801f-e64d-5ff9-8ef0-240769128791',
  'Catherine Nichols Gunn School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9232'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4ee0bafa-f5d5-530b-8c0f-bd05257325b8',
  'Stanley Jones School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9233'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2aef4d3e-383e-547e-82cc-4dc454e9eff3',
  'Sunnyside School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9234'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8356be5e-e4f4-5917-9a50-32d0ca402926',
  'Thorncliffe School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9235'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '52751ae9-6aba-5a13-8717-a5ad3ba2c10a',
  'University School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9237'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ff4e9f4f-17fa-5537-af9e-1e60301d96e5',
  'Varsity Acres School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9238'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '41c3589d-f079-5032-8591-7164b7781658',
  'Vista Heights School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9239'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4af26e75-c098-5ef2-b3e9-8dc10e21c5b5',
  'Dalhousie School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9240'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '28c121f5-e373-53e8-a80e-a630a08627b3',
  'Marion Carson School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9241'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '936cdd1a-2aa7-5565-b950-92882bc5617c',
  'Dr. J. K. Mulloy School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9242'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6dbc7f52-dc2e-5b18-ba0a-9a02cd4eb18c',
  'Roland Michener School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9250'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '04b8fd65-1dd8-505b-964e-33b038ca3103',
  'Silver Springs School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9256'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2b50cf88-a542-5774-91c4-095eb47353bd',
  'W. O. Mitchell School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9257'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a4aa5a19-530a-57b5-9a30-a2a6704bfcc8',
  'Alex Munro School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9261'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4b808a38-6648-505d-b67f-b4cf5819f8d0',
  'Deer Run School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9265'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '43893259-ee60-5c84-9ace-a83947d7e157',
  'Woodbine School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9266'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a6ef43d3-5a2d-5e08-a12e-bfa25a534120',
  'Sundance School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9267'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '92b66cf8-eefd-5536-8787-08cbf1c4871c',
  'Erin Woods School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9269'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f7af5593-2aa5-5ef6-92b4-b309fcc53137',
  'Janet Johnstone School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9270'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'eb7f8a96-ee22-595f-a775-0be32e248de9',
  'O. S. Geiger School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9271'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '26810707-d771-516a-982c-42488e8800f0',
  'Hawkwood School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9273'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '53d14021-f583-5472-a2cf-18169ca78593',
  'Acadia School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9300'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '77afbe0e-28e3-57cc-8c1b-462a8601c1c1',
  'Braeside School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9305'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ea628463-b891-58de-b4dc-90e351df21f9',
  'Chinook Park School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9306'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '87045ce3-0b75-545a-860e-5517b4c5eb43',
  'Ethel M. Johnson School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9310'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '382985df-59a9-54b5-b8f8-d08c7698c273',
  'Eugene Coste School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9311'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5c3afc1c-ad6f-5aea-b779-f6031db72b5e',
  'Haysboro School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9316'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1100c582-9203-50cf-9dcd-8e9cc0177de8',
  'Keeler School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9318'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '182145a8-d1f9-54fc-b228-fd273c70396f',
  'Le Roi Daniels School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9320'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '77aa601a-cf76-5597-99b6-277569125f24',
  'Maple Ridge School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9321'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ff81747f-2e05-5584-a31b-0fb6e3effbd6',
  'Marlborough School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9322'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '144aa16e-1d8c-550c-b042-e613e1b325fa',
  'Patrick Airlie School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9327'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '15b39ca2-cd3b-506a-9596-7d2767db90ac',
  'Valley View School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9330'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '75176b0d-4364-544a-b4be-4410625e1551',
  'Willow Park School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9331'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9099a915-a981-5656-9d9e-428130a7f194',
  'Nellie McClung School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9333'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '10a35903-8adf-5194-84e4-7cdcf4a56dd9',
  'Lake Bonavista School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9334'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c797905e-6fda-52b4-9577-b56e6394b754',
  'Andrew Sibbald School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9336'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '00e08f6f-9e55-5684-ae4e-52fd3584c162',
  'Cedarbrae School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9338'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4d403f89-b01a-51f4-a583-77b7935da212',
  'Chris Akkerman School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9339'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fbbe1808-390f-52ff-abe3-dca64ced14a3',
  'Prince of Wales School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9341'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4dc743d1-2e1e-503e-86a3-895102997e1e',
  'Guy Weadick School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9343'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '27c0850a-e39d-5d53-ba47-8893eac4cd82',
  'West Dalhousie School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9344'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f95c0b58-9ab2-5225-a773-e11c609443e8',
  'Dr. Gordon Higgins School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9346'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fa0c4d96-1a28-5c8f-aecd-4ca04006331f',
  'Douglas Harkness School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9347'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'abf8b3d3-5d7d-5cb6-90da-5e56fd7fbda6',
  'Colonel J. Fred Scott School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9348'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '11d0e1fc-734b-575f-966e-7623b06dea2b',
  'Dr. Gladys McKelvie Egbert School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9350'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6249927d-52a4-587b-84ae-56392be3ff77',
  'G. W. Skene School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9351'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1fe2460c-cea5-5843-aa71-78f4aa2b7d74',
  'Cappy Smart School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9353'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8c59135b-a1c2-532b-80dc-16a3aeb29a31',
  'Sam Livingston School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9354'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7dd9b58a-d688-5d96-a7c2-38a84ecc9d69',
  'Canyon Meadows School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9355'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '993c5594-c6a8-558f-b5a7-21325ef82fad',
  'Penbrooke Meadows School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9356'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9b430b08-194a-563e-bfe1-11a0bf4a3e27',
  'West Dover School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9357'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8012c0f6-bdc8-564f-b3ca-e826d86f07c5',
  'Rundle School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9358'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f0cb4afe-e990-5641-a725-6daa1990591a',
  'Pineridge School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9360'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '482c0f1a-6f83-537f-bc49-3097b899013b',
  'Chief Justice Milvain School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9361'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6580d687-9168-5eeb-b183-a99a90d65155',
  'Haultain Memorial School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9362'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0bf05095-12b7-5df0-93f7-2c5d3bff8a46',
  'Midnapore School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9363'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f6921d27-ae6e-56c5-a2fc-6cb152f43c7f',
  'James Short Memorial School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9364'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd1609987-7d3d-53fd-98f2-0a408d6afa10',
  'Sunalta School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9368'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fd0a06fe-07f3-51f3-b301-466ed48db97a',
  'Banting and Best School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9369'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a3c52218-c341-52ab-bb80-47912402d6fc',
  'Woodlands School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9371'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f4368245-936a-548f-9e10-f602a3ae6416',
  'Beddington Heights School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9372'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1b506f05-91f0-5b6a-a571-b5b8146357e8',
  'Cecil Swanson School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9373'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '119f7056-7523-5d01-8878-60c1b2690cea',
  'Ranchlands School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9374'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f269ebcc-e584-577f-839a-232fbb900fbf',
  'Falconridge School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9375'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '615e8b0f-61b5-581f-a205-faaf63352d4f',
  'Abbeydale School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9376'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3541e783-ed9d-5054-aad4-09ff8d79c35b',
  'Annie Foote School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9377'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1f6ca920-1abf-599b-a4ae-7533eccdadf9',
  'Grant MacEwan School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9378'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a1cdf4ba-57d1-5c9e-9bd8-761e58530fe6',
  'Edgemont School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9379'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5931036c-a96c-54ef-b04b-3dc7732c3adb',
  'Olympic Heights School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9382'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd8ff2cac-b78b-5378-aa20-102e456a3a7d',
  'Simons Valley School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9383'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9a339ced-04a3-5cff-a1b7-7406430de36d',
  'Fish Creek School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9384'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6f96c813-ae3e-5b4f-a5bd-841f305d01cf',
  'McKenzie Lake School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9385'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a90e2381-4883-5169-9be0-f0ec6ad8ff7b',
  'Riverbend School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9386'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f765ca0c-41a6-5651-9393-19f95352709b',
  'Calgary Home Education',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9425'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '42e0cc03-12ba-5375-82c8-d42aebd16844',
  'Adolescent Mental Health Services',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9512'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9f762718-b966-5815-acbd-eabed2c885b0',
  'Balmoral School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9601'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '12a3b90e-dc02-5223-9158-e3131a4d0475',
  'Colonel Walker School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9602'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a3c78b54-4782-52f1-acd9-d0c7238729c1',
  'John Ware School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9603'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a9ba1e48-af5b-55e7-949b-0ccd0bc584d4',
  'King George School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9608'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a1507461-0d80-5f07-bf39-6a6fd8b9765c',
  'Riverside School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9609'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6bf70002-5542-5c56-812c-59eac42660f1',
  'Rideau Park School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9610'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '590a4ce8-260f-5eba-984e-a2a7dc59f088',
  'Thomas B. Riley School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9611'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bcd83b1b-894e-55d2-b9ff-6ba3b662928c',
  'Ian Bazalgette School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9613'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a48577b2-b8e2-5cc3-9b21-9356d4107bb0',
  'Rosedale School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9618'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fecc32de-3552-591f-9096-235d82bab433',
  'Colonel Macleod School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9620'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7bc60acf-6b45-5302-bdb7-e32426e0fd05',
  'Branton School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9621'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '409bfb76-6a9a-5661-bdab-fe1abdbf3e79',
  'Colonel Irvine School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9622'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '635a497e-fdb6-5ed8-957c-4aaabd7fc8fe',
  'Bob Edwards School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9623'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9cd9d451-5f24-51ef-a776-6f3078d1cdc0',
  'Louis Riel School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9625'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '70f205c6-c42d-55d3-9296-e1e03eea2630',
  'Louise Dean School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9626'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '205acca5-fc0a-550d-8c60-1baefdc03dd7',
  'Elboya School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9627'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f53c92aa-ddf6-5c48-84ad-be2d43a6e9c7',
  'Vincent Massey School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9628'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f1756dfe-35be-5462-9147-dcdcbcd3f5e8',
  'Dr. Oakley School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9630'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e88f1a2f-fd96-51f6-8cb9-5e24db191ffa',
  'Woodman School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9631'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '05bcf534-197e-5eaa-90c4-289fc21e8916',
  'Sherwood School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9632'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd9af4499-1e2d-545c-af55-104aeefa6c46',
  'Fairview School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9633'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f44c87b6-3b2d-5401-95e5-716be265f850',
  'Georges P. Vanier School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9635'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5ebf8ee9-8d0b-579f-88ae-d39028a5fc76',
  'A. E. Cross School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9638'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5791d9f7-1b31-57c9-b328-a9320634da96',
  'Mount Royal School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9639'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c97ee57a-0a51-584b-9cb8-7801321b8fee',
  'Senator Patrick Burns School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9640'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e01fb8f5-e584-5846-8f35-10463b4b5fe1',
  'David Thompson School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9641'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '13474d35-8e7b-5233-9d42-68963a498ec9',
  'Harold Panabaker School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9643'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1a7c4fe4-eae9-5ba6-a5e0-2b53dabc27c6',
  'Ernest Morrow School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9644'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '94752b5e-43ca-57f7-9a22-0b97d087dcdf',
  'Bishop Pinkham School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9645'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3b36031a-d000-5e67-a6a2-dc44dcf244e7',
  'Simon Fraser School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9646'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f7d469ec-2366-5d54-80b0-2616ef61fc1b',
  'Sir Wilfrid Laurier School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9648'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'faf56a6e-0310-59db-8a2e-e4edc74748ec',
  'Sir John Franklin School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9649'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '07fac128-ae0d-51c9-9d30-60264b88d249',
  'F. E. Osborne School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9651'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'da8a8645-ff4a-5047-b926-47fc76b4a41a',
  'Sir John A. Macdonald School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9652'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd7432ac5-5923-56ac-b61d-35514f75168d',
  'R. T. Alderman School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9653'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7fb7b2e4-92e0-5f1c-b588-08e5e2a058bc',
  'Nickle School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9654'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ca63f409-5e87-501b-b602-52a7c3ab8ff5',
  'Robert Warren School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9655'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5e4d4fac-3a1c-5c1a-899c-ff0cb7096c9e',
  'H. D. Cartwright School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9660'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6cb57602-a763-58f1-89f4-a17541e474de',
  'Clarence Sansom School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9682'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b6833c2d-8a1f-5028-b6ce-d0914417c46c',
  'Wilma Hansen School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9685'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7c8219dd-f39b-512f-810f-97649b0b68bf',
  'Annie Gale School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9686'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '99958535-5904-5548-a215-2d1937ac8a0d',
  'West View School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9687'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b0a4ad9e-920c-5756-89ab-fd85bc750252',
  'Terry Fox School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9689'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9de09e27-3950-5fea-b1f4-1728a69fd928',
  'Tom Baines School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9690'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6807a92c-bde8-5ae7-879c-f379edeecbea',
  'Queen Elizabeth High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9806'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ef6b5bde-f229-5c35-ac6f-28e35fabe817',
  'Forest Lawn High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9813'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6af2c15e-7c9b-5fbd-8730-be8b8554c349',
  'Crescent Heights High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9815'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c637e732-c2ab-5049-b4d8-b9ff45dbc611',
  'Western Canada High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9816'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c52a2551-e27e-536c-b0b7-8d882f479d63',
  'Chinook Learning Services',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9817'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c8841919-f99b-534e-9652-f1f5bc14b363',
  'Central Memorial High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9823'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f6463206-c4c9-55c7-9df9-77b1daa88e08',
  'James Fowler High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9825'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '293a2423-d99e-5edf-943f-6aaa19eab343',
  'Ernest Manning High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9826'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b641630b-8c2a-5e96-bfe3-1a6b98ed0616',
  'William Aberhart High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9829'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1d454502-4048-5772-b037-4f5b6e5854e8',
  'Henry Wise Wood High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9836'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4e746352-28b8-5c30-89a7-1b7b71e767fa',
  'Bowness High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9847'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6f0e102f-0d66-537b-80a2-9324e7ffc029',
  'Lord Beaverbrook High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9850'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '81cb2afd-2b7f-53f2-8e76-7fbbc303eb96',
  'Jack James High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9856'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '614c2d01-29b7-56cd-9c44-94c577fce191',
  'Sir Winston Churchill High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9857'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '887f37d0-d8d4-540e-919f-9580e3466ec6',
  'Dr. E. P. Scarlett High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9858'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '889acdef-ebc9-5d0b-8b9b-591393cf0bc7',
  'John G. Diefenbaker High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9860'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'faf767da-3323-5b5c-8713-738fe914f68d',
  'Alternative High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9863'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3d00f632-7c2f-5920-8f92-2e2090fb0744',
  'Lester B. Pearson High School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9865'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9b29ade8-fc53-5675-a1e2-607fe16b82b7',
  'Discovering Choices',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9868'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c8477b57-6b30-5fe9-a7ad-7ffc84e48593',
  'Dr. Gordon Townsend School',
  '90a43ff3-9217-582c-bc5f-ce9525f5147a',
  'free',
  'Alberta Public school. Authority: The Calgary School Division. Code: 9886'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '22a9c53b-037b-5dbd-a8de-2b6cceb12088',
  'Immanuel Christian Elementary School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 0305'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0b907bfc-15d1-559f-b43b-bf7f7d136a23',
  'G. S. Lakie Middle School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 1097'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '09c0450c-c3e5-5167-9337-8c4aa989683c',
  'Stafford Ridge School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 1380'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b1eeb2d4-09bd-509d-b50e-bb750e4b4684',
  'Chinook High School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 1465'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f4ac6d1f-a719-5b55-9a30-192375effa81',
  'Coalbanks Elementary School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 2144'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7aa0504b-c638-5bdb-863d-15fc303a505f',
  'Senator Joyce Fairbairn Middle School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 2198'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c2f87c60-9718-585a-a59d-f2ef9e8bd07c',
  'Dr. Robert Plaxton Elementary School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 2334'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1b926d86-dedc-5ab6-bf3c-67b13be28c77',
  'Ecole Agnes Davidson School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6435'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0592fc08-6d95-5e41-8b84-910adff1c428',
  'Fleetwood Bawden School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6438'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0b8915f7-b4ea-5beb-8179-5c08e21a08be',
  'Galbraith School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6439'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '36ed6218-9939-5d13-8b2a-92848978d91a',
  'General Stewart School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6440'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2cc75b94-5767-5c59-8463-70e3a6902db0',
  'Gilbert Paterson Middle School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6442'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fcc5aa8a-fe22-55ed-9006-7cc01f8dca8a',
  'Lakeview Elementary School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6444'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1943fc85-209d-5f6d-8c47-940c19d0d624',
  'Nicholas Sheran Elementary School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6445'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2df5b7af-b68e-55bb-bd6e-230ed8c29df8',
  'Lethbridge Collegiate Institute',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6446'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2a97a7a5-d378-5ceb-b7f0-ce08a031b2ee',
  'Park Meadows School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6447'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '161e67f2-e476-5e6c-bcb2-79fed46a5129',
  'Victoria Park High School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6449'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a94323ad-d78a-5c4c-a8dc-ec8c81d1f97a',
  'Senator Buchanan Elementary School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6450'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5dff31e7-7a27-587c-bca8-3ddde1d09e38',
  'Dr. Gerald B. Probe Elementary School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6451'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e87916b1-f917-535d-894d-0ae9d5d306a7',
  'Westminster School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6452'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '246308db-f4db-5149-b8a2-aa7b2bef26e2',
  'Wilson Middle School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6455'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3fff5e1f-9bae-5780-bcbf-db88c0d0b6b8',
  'Pitawani School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6456'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd7c7ba58-1053-58f2-aa92-a41b0e838ec5',
  'Mike Mountain Horse School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6457'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0846de95-2c80-5a42-80d8-bc6765351fcd',
  'Harbour House School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6459'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '27dd6ce6-6606-51a0-89a8-d51a849b5615',
  'Winston Churchill High School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6466'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '07b59884-2eea-5200-96dc-fa79c568cab6',
  'Immanuel Christian Secondary School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6491'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c19902af-47a5-5783-9f7f-ebfc93e573b4',
  'Lethbridge Christian School',
  '18abed62-e44d-59d6-8756-7db0023edb4c',
  'free',
  'Alberta Public school. Authority: The Lethbridge School Division. Code: 6497'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c362a589-b54c-5076-9289-003a227bbd1f',
  'Pathways School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 1239'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cde7b683-6893-54d5-a809-f5d5dd16dcf5',
  'Dr. Roy Wilson Learning Centre',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 1728'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0db8d91f-7dd2-592b-9f6f-4fd1db254d79',
  'Dr. Ken Sauer School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 2142'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a842b385-23e6-596d-ae7f-143b6dc2bb77',
  'Community Early Learning Program',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 2242'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '74544000-71b0-5727-bf12-2be65b8aa06c',
  'The Hub: Online Community School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 2389'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0ffa8b39-591b-5f84-ab8f-cc4cdcb0dc41',
  'Alexandra Middle School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6841'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1eb03c7b-1a21-5248-bf0d-86607c694993',
  'Connaught School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6843'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fb95c968-a134-5839-9ea3-2cf8f3cee3c1',
  'Crescent Heights High School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6844'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a6253b73-bf5a-59b8-98d2-d34531c42b3e',
  'Crestwood School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6845'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '392a09cb-918e-5df5-ac87-fdc01e3471d5',
  'Ross Glen School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6847'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f51a9651-3a35-5e5b-9745-01eaf49dfbd0',
  'Elm Street School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6848'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2ae89d67-c047-5d8b-816c-57c12c5090a9',
  'Herald School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6849'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd803f785-5209-5a41-88ac-5d03d6fdce39',
  'Medicine Hat High School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6850'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5faf79ff-412a-5321-9650-9d318d69198a',
  'River Heights Elementary',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6852'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a5b1c3b2-faad-5e94-af02-8f6c384e4b20',
  'George Davison Elementary School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6854'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c32a5715-8a9a-5fe7-9a9b-30ed3c7c70e0',
  'Vincent Massey School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6856'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f6e887e2-4903-5e10-b240-045e368eb5ff',
  'Webster Niblock School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6857'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ec122c7b-32d5-54dd-9466-0d52a03a96eb',
  'Southview Community School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6858'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b594b015-6473-572f-b136-4d6efd56bff7',
  'PAS',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6864'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '59b0686a-0d32-5c74-b14f-a517b31cb92f',
  'Medicine Hat Christian School',
  'c0504ef0-0884-588f-bc3d-11351fa98359',
  'free',
  'Alberta Public school. Authority: The Medicine Hat School Division. Code: 6896'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e54c8d8d-220d-551a-bd8a-7aaf6e0082b6',
  'Canadian Rockies Education Outreach',
  '3c0ae25b-d630-503f-8c66-9d4cc272d36c',
  'free',
  'Alberta Public school. Authority: The Canadian Rockies School Division. Code: 1322'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a80b5c30-50fb-5c89-b1c6-4185b2fa57fc',
  'Alpenglow Community School',
  '3c0ae25b-d630-503f-8c66-9d4cc272d36c',
  'free',
  'Alberta Public school. Authority: The Canadian Rockies School Division. Code: 1755'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '269eeefc-fe09-51d3-ab1e-fd357d41dc3a',
  'Banff Community High School',
  '3c0ae25b-d630-503f-8c66-9d4cc272d36c',
  'free',
  'Alberta Public school. Authority: The Canadian Rockies School Division. Code: 5235'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4421e559-71af-593f-9489-6e3395de961b',
  'Banff Elementary School',
  '3c0ae25b-d630-503f-8c66-9d4cc272d36c',
  'free',
  'Alberta Public school. Authority: The Canadian Rockies School Division. Code: 5236'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '20cf14b3-7b37-5022-86d1-d4477248ad2b',
  'Lawrence Grassi Middle School',
  '3c0ae25b-d630-503f-8c66-9d4cc272d36c',
  'free',
  'Alberta Public school. Authority: The Canadian Rockies School Division. Code: 5238'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '28781a70-2541-5441-b7ac-be78de8f0e28',
  'Exshaw School',
  '3c0ae25b-d630-503f-8c66-9d4cc272d36c',
  'free',
  'Alberta Public school. Authority: The Canadian Rockies School Division. Code: 5239'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '446dda76-177d-5267-b6b2-1ac84b3e58ba',
  'Elizabeth Rummel School',
  '3c0ae25b-d630-503f-8c66-9d4cc272d36c',
  'free',
  'Alberta Public school. Authority: The Canadian Rockies School Division. Code: 5242'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6f958b41-4e0f-5b66-b4e9-971437218290',
  'Canmore Collegiate',
  '3c0ae25b-d630-503f-8c66-9d4cc272d36c',
  'free',
  'Alberta Public school. Authority: The Canadian Rockies School Division. Code: 5243'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '04093027-3164-5dc6-9503-9ae79d09aebc',
  'Red Deer Regional Hospital Education Program',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 0574'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4d18c7a3-8c08-5d7b-93a6-9c2d15cf0d0f',
  'Mattie McCullough Elementary School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 1063'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bbb5962d-9fe8-58bc-861d-c152926e8a23',
  'Ecole Barrie Wilson Elementary School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 1783'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fa35731b-0a05-5df4-8107-96a57e7c90ca',
  'Escuela Vista Grande',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 1952'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6793678e-b04c-565b-8ec5-bb06171c2756',
  'Don Campbell Elementary School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 2143'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9fa715b8-94e4-5071-bee0-ef98b83e842d',
  'Hunting Hills High School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4433'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5404cc58-4b56-52c1-b0e2-59670b01c7b8',
  'Outreach School Centre',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4435'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7a0fbef0-3193-5590-b5f2-371e03e2654d',
  'Annie L Gaetz School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4436'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '87c3d1b2-b0e3-52a8-a52d-74a89aee44e4',
  'Central Middle School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4437'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd518755a-155b-523e-8b8d-ca24b4069513',
  'Eastview Middle School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4439'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a7a6c15e-6bbe-532f-9489-8ea7c5002104',
  'Fairview School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4440'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3bdb5b78-f8ad-54e8-bd0e-59a63e65117f',
  'George Wilbert Smith School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4442'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '93d34ad0-2d5d-5354-a4de-e6f44349419f',
  'Joseph Welsh School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4443'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f13aad14-7517-5ee6-b8d9-4aae0c7d6c58',
  'Lindsay Thurber Comprehensive High School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4444'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7a8f1b22-59ca-53d8-b490-a2984865e5bf',
  'Mountview School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4445'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f52a4419-a918-5d52-9d6b-3d6d4b5b8f58',
  'Aspen Heights Elementary School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4447'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '28c9249b-8ca1-59fe-b85b-8d0141db7a49',
  'Oriole Park School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4448'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7b166be6-dde5-5f49-aa53-aa3eec6ef1d3',
  'West Park Elementary School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4452'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5e135d77-e2a9-5704-83c6-51f81a277055',
  'Westpark Middle School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4454'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ab6e6c6e-6a9b-5ff5-9462-adfb24929fb8',
  'G H Dawe Community School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4455'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9d875988-d1a7-5e79-b3fa-8749d594d6b1',
  'Quest, Stabilization and Secure',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4457'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c37720d5-848d-5aaf-af12-8bd11c34f985',
  'Normandeau School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4458'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'db15e2de-7d46-58b0-bc8c-07beb046333d',
  'Quest, Assessment',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4461'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5358d071-f849-5704-abb7-50f6eddc527c',
  'Glendale Sciences and Technology School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4463'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2a3d8826-09af-570a-9b08-1b8ac495a5a2',
  'North Cottage High School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4465'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '61e9416b-4f48-52f0-b46d-11053146a668',
  'Gateway Christian School',
  'dca610fd-a0df-5e89-b322-0800619da089',
  'free',
  'Alberta Public school. Authority: The Red Deer School Division. Code: 4491'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f466365d-7616-501a-b18b-62ccb9fa009e',
  'College Park School',
  '32a2c104-cb9d-5fdc-9266-7d35e1c28f95',
  'free',
  'Alberta Public school. Authority: Lloydminster Public School Division. Code: 1779'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a0cff9ee-d209-5f86-989f-4f19db736c8f',
  'Lloydminster SD99 Home School',
  '32a2c104-cb9d-5fdc-9266-7d35e1c28f95',
  'free',
  'Alberta Public school. Authority: Lloydminster Public School Division. Code: 2347'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '53fb1e02-984f-55d8-b77c-05db0eaa4a5b',
  'Lloydminster Comprehensive High School',
  '32a2c104-cb9d-5fdc-9266-7d35e1c28f95',
  'free',
  'Alberta Public school. Authority: Lloydminster Public School Division. Code: 3840'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4414e6f3-e8cd-5248-b884-a823398b235e',
  'Queen Elizabeth',
  '32a2c104-cb9d-5fdc-9266-7d35e1c28f95',
  'free',
  'Alberta Public school. Authority: Lloydminster Public School Division. Code: 3845'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1153e960-5e7f-5d70-a5e2-565a58700f43',
  'Rendell Park',
  '32a2c104-cb9d-5fdc-9266-7d35e1c28f95',
  'free',
  'Alberta Public school. Authority: Lloydminster Public School Division. Code: 3846'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f5c25cb3-ba71-55da-9dd1-7c4250fce75a',
  'Bishop Lloyd',
  '32a2c104-cb9d-5fdc-9266-7d35e1c28f95',
  'free',
  'Alberta Public school. Authority: Lloydminster Public School Division. Code: 3848'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '74ba0d88-6c4a-5439-8d10-db6751c3831e',
  'I.V. Macklin Public School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 0481'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e96042a5-3517-51c8-b684-392f6b5c5a0c',
  'Avondale School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1140'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '16b5eda8-77f9-5a10-9565-600fef84591e',
  'Grande Prairie Composite High School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1141'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e47fc3e4-edce-5380-a551-8912ca4e45d3',
  'Alexander Forbes School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1142'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c82c1083-79b1-5a91-969f-a510e97864c5',
  'Hillside Community School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1143'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '45027e54-63e7-5f6c-9036-6f7aa41967f9',
  'École Montrose School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1144'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8e17277a-11d5-52b3-bf49-8066d59bf26b',
  'Swanavon School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1146'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5e9ca00a-806e-5f3d-bcef-ca1e3a619c83',
  'Parkside Montessori',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1147'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b29c05ce-9787-5168-bf9b-25fe80cb6568',
  'Crystal Park School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1150'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8bd657b5-b253-57a1-a29c-b65441e03a2f',
  'Aspen Grove School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1152'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a55544d1-9e79-5a00-ad2d-6d3b93930e4b',
  'Bridge Network',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1153'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6f093d37-0b28-52d8-850d-d26ae23f35e3',
  'Grande Prairie Public School District #2357 Home Schooling',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1154'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '897fd80c-a630-5c54-a913-d3f379b52461',
  'Grande Prairie Christian School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1192'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5f87877e-62ad-54d1-b4ea-35d14e4bfd50',
  'Derek Taylor School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1372'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7b9ce7dc-cc7e-5740-b626-c50815abb51e',
  'Maude Clifford Public School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1461'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9f5af348-c842-54f0-a0a3-a966fbc52282',
  'Charles Spencer High School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 1761'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6be2f3fa-fcce-55e6-93b1-2cbcff59e129',
  'Riverstone Public School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 2076'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b44d9356-c915-54ea-8374-e4c2f919c618',
  'Isabel Campbell Public School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 2077'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '33b78306-b5ac-5b47-823d-5b02208dbae1',
  'Roy Bickell Public School',
  '6c2cfa67-e901-5c6b-abc5-fba6fb5267d1',
  'free',
  'Alberta Public school. Authority: The Grande Prairie School Division. Code: 2148'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '86f1236e-a300-5834-a6bc-196a2edf1f81',
  'Fort McMurray Islamic School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1256'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c858f347-a0ad-50c5-8436-22354745ccfd',
  'École McTavish Public High School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1559'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '26b0e89e-1a33-5f93-827f-a9027c80d7df',
  'Walter & Gladys Hill Public School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1765'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ed9bca15-fb49-5e42-ac16-28497760144e',
  'Dr Karl A Clark Elementary',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1841'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '39d87a56-d615-57e2-b24b-542140b81480',
  'Beacon Hill School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1843'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6b072ddf-3b78-52bc-aeb3-1e4e46454623',
  'Thickwood Heights School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1844'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e3cbf405-832f-5154-929c-2dde09dbba53',
  'Fort McMurray Composite High School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1845'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '259b5be6-ea0a-5741-a7bd-8b5fc9cbc330',
  'Westview School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1848'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a1bcf7b0-d99b-5220-85b6-69e5a3991ab6',
  'Greely Road School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1853'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cba987af-1c08-502f-8f69-7cc043c8f77e',
  'Ecole Dickinsfield School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1854'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c2b6c86e-cded-5459-bc0f-12c14f9a60d0',
  'Timberlea Public School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1855'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4782bde0-85fb-501d-877b-f6e8b90e61b5',
  'Westwood Community High School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1857'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7e3c9720-3869-5729-b67a-4fc0b58e5ec1',
  'Frank Spragins High School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1858'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a6c1fdc9-7268-5a7f-ad68-e84817afceb3',
  'Fort McMurray Christian School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 1864'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2a234e4b-0596-59ef-9ea2-90bf0b8b8d89',
  'Dave McNeilly Public School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 2074'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0bb855eb-8649-5f8c-9299-58e774614c6e',
  'Christina Gordon Public School',
  '1f5fd564-69b7-52ad-9692-b1a3a2a20e7d',
  'free',
  'Alberta Public school. Authority: The Fort McMurray School Division. Code: 2075'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3a1355d5-ba45-55ad-a5e8-cc68aba5efd7',
  'Lois E. Hole Elementary School',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 1966'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'faf89143-f6c8-5f4d-81fe-8d47b9134a76',
  'St. Albert Public Schools Preschool',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 1974'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7e5150f8-345f-553b-8ee1-0bce27b45a76',
  'Joseph M. Demko School',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2188'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f6bc74e0-138b-530b-b594-438d56449e88',
  'Leo Nickerson Elementary',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2540'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '27db780d-edbf-5a06-a36d-5a0ff59780fc',
  'Paul Kane High School',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2541'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '69101136-6ae0-54fc-bcf1-72803aba4f4d',
  'Sir Alexander Mackenzie School',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2542'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '83da0d1e-1996-5856-a931-f72e89544b51',
  'Hillgrove Campus',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2543'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0838862b-dd59-5547-9741-b0de6bb1b464',
  'Lorne Akins Junior High School',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2545'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '99dabe66-18e0-5bb2-ab97-463217dc7f83',
  'Ronald Harvey Elementary',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2546'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b668e2c6-15ae-5b3e-bdb5-c3d8a4cb8328',
  'William D Cuts School',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2550'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e1f35f68-632d-5894-b97e-cf1d3d0d715c',
  'Wild Rose Elementary School',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2551'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bb8733ba-6200-5b5d-a84f-b4a50447c1f7',
  'Elmer S Gish School',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2552'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4fe8aca1-d9cf-5e45-93b8-d01b941576d8',
  'Kinosayo Elementary School',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2554'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1f232a79-99b8-5213-9b7c-6fedd151f69d',
  'Bellerose Composite High School',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2556'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '134ad790-272f-57ef-8b3b-d3426b71e42e',
  'Muriel Martin Elementary School',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2557'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6b09672b-9cc5-5277-9c19-0096c5f7927a',
  'St. Albert Public Outreach',
  '96c00458-863f-5eeb-b172-dcf5479d6551',
  'free',
  'Alberta Public school. Authority: The St. Albert School Division. Code: 2558'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '22c0d2b7-9af8-5010-a6d1-498812fb94bb',
  'Mother Teresa',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 0489'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '407a5bb1-2b9b-5615-b452-d5c3a79396e5',
  'St. Francis of Assisi',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 1123'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '618cf4ea-0560-5493-b589-257d807ad38c',
  'St. Marguerite Bourgeoys',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 1124'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '540eaf06-c714-5653-9d12-8f94f6c18ae2',
  'St. John Paul II Catholic Outreach School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 1253'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bcdb9036-5f1e-59f2-b9e7-971bea27241c',
  'St. Dominic High School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 1272'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0c313e1e-67c2-5b07-9919-734744cd676c',
  'Our Lady of the Rosary School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 1369'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a7bb9071-bb3a-5eaa-a95a-38fa2e4b6e4e',
  'Holy Trinity School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 1497'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ed847821-78c1-501b-8f9f-699cc9f71ca3',
  'Father Henri Voisin',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 1697'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3cf8db71-97bd-5ddf-9bf5-120a2b016423',
  'St. Joseph High School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 1923'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9255a22f-1cb2-5cf8-a944-8bbf71918939',
  'St. Gregory The Great Catholic School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 2079'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '97eb4867-eae1-5e0a-b000-7c65c483db3c',
  'St. Lorenzo Ruiz Middle School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 2476'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0bb4c638-c911-55cc-899a-81261b0422be',
  'St. Matthews Catholic School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 4170'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '698cfa06-3f6d-5d19-9f2e-83ac892969a6',
  'Ecole Secondaire Notre Dame High School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 4471'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd56e5d1c-0dd4-59f7-8f04-219310da0036',
  'Maryview School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 4472'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7a9bdfea-7ddb-578d-88d0-72c40bb2ec5c',
  'Ecole Camille J Lerouge School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 4473'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '422ad520-b902-5e7d-8471-f8cd7758189b',
  'St. Martin De Porres School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 4475'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e1569f18-81e3-59c6-8464-a55280d1f05d',
  'St. Thomas Aquinas School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 4476'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2183d717-ef4f-56db-8680-16a741ab141e',
  'St. Elizabeth Seton School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 4477'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4ae621fd-47e3-5042-9f09-ae39a5555333',
  'St. Patricks Community School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 4478'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ca21c85e-74d3-5143-8035-e6409760dfc6',
  'St. Teresa of Avila School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 4480'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '67c60f94-debf-5706-b94b-4e4f9ffcc8ac',
  'Holy Family School',
  'f2a064b5-464d-58cd-80c2-40f8b80d958e',
  'free',
  'Alberta Separate school. Authority: The Red Deer Catholic Separate School Division. Code: 4481'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dff060e8-b013-53da-9b0a-084e8b2b5c3a',
  'STAR Catholic Outreach School',
  '9857544b-ba36-55a9-abd5-d23a840771d3',
  'free',
  'Alberta Separate school. Authority: The St. Thomas Aquinas Roman Catholic Separate School Division. Code: 1075'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f582fe37-ba06-580f-8151-c7ef62dbd6f7',
  'Father Lacombe Catholic School',
  '9857544b-ba36-55a9-abd5-d23a840771d3',
  'free',
  'Alberta Separate school. Authority: The St. Thomas Aquinas Roman Catholic Separate School Division. Code: 1312'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0068705c-4a8a-53a3-b7d9-caeb620accb6',
  'Holy Trinity Academy',
  '9857544b-ba36-55a9-abd5-d23a840771d3',
  'free',
  'Alberta Separate school. Authority: The St. Thomas Aquinas Roman Catholic Separate School Division. Code: 1328'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b252a082-3cc7-54e6-970b-c83be7502eef',
  'Academie Saint-Andre Academy',
  '9857544b-ba36-55a9-abd5-d23a840771d3',
  'free',
  'Alberta Separate school. Authority: The St. Thomas Aquinas Roman Catholic Separate School Division. Code: 1496'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f70deb93-ae70-5cde-9baf-a5c8b17937a7',
  'Father Leduc Catholic School',
  '9857544b-ba36-55a9-abd5-d23a840771d3',
  'free',
  'Alberta Separate school. Authority: The St. Thomas Aquinas Roman Catholic Separate School Division. Code: 2059'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '30520c73-b3b5-5b27-9668-0158c7a8acd5',
  'École Mother d''Youville School',
  '9857544b-ba36-55a9-abd5-d23a840771d3',
  'free',
  'Alberta Separate school. Authority: The St. Thomas Aquinas Roman Catholic Separate School Division. Code: 2060'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '38dd0835-2d0a-5da5-b20f-be19ff261aba',
  'St. Anthony School',
  '9857544b-ba36-55a9-abd5-d23a840771d3',
  'free',
  'Alberta Separate school. Authority: The St. Thomas Aquinas Roman Catholic Separate School Division. Code: 2270'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cae017c1-e37e-5ea8-a232-ecec46697861',
  'Sacred Heart School',
  '9857544b-ba36-55a9-abd5-d23a840771d3',
  'free',
  'Alberta Separate school. Authority: The St. Thomas Aquinas Roman Catholic Separate School Division. Code: 3170'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9f38aaf2-0712-5291-ab4c-90638d741b94',
  'École Notre Dame School',
  '9857544b-ba36-55a9-abd5-d23a840771d3',
  'free',
  'Alberta Separate school. Authority: The St. Thomas Aquinas Roman Catholic Separate School Division. Code: 3270'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4ae950c6-59ea-582d-b049-ba2c22fc7352',
  'St. Benedict School',
  '9857544b-ba36-55a9-abd5-d23a840771d3',
  'free',
  'Alberta Separate school. Authority: The St. Thomas Aquinas Roman Catholic Separate School Division. Code: 3271'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0fcdabc7-05f1-5323-82a2-184bcb279986',
  'Christ the King School',
  '9857544b-ba36-55a9-abd5-d23a840771d3',
  'free',
  'Alberta Separate school. Authority: The St. Thomas Aquinas Roman Catholic Separate School Division. Code: 3272'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bdc9787c-efec-5d76-b6b8-b7b36d9f0d2a',
  'St. Augustine School',
  '9857544b-ba36-55a9-abd5-d23a840771d3',
  'free',
  'Alberta Separate school. Authority: The St. Thomas Aquinas Roman Catholic Separate School Division. Code: 4270'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a9c45b7b-b491-56f7-b639-78757ba73d53',
  'Holy Family Cyber High School',
  '8c0c8c45-4448-53fa-9a4d-bbb06d80990d',
  'free',
  'Alberta Separate school. Authority: The Holy Family Catholic Separate School Division. Code: 0311'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9964d9c3-103b-5029-9a70-37f4decd025d',
  'St. Stephens Catholic School',
  '8c0c8c45-4448-53fa-9a4d-bbb06d80990d',
  'free',
  'Alberta Separate school. Authority: The Holy Family Catholic Separate School Division. Code: 1270'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9b6fbc83-3be6-5487-ab13-9d29f27a208b',
  'Holy Family School',
  '8c0c8c45-4448-53fa-9a4d-bbb06d80990d',
  'free',
  'Alberta Separate school. Authority: The Holy Family Catholic Separate School Division. Code: 1570'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2d4364d8-033a-5cc9-bf39-54206c0301ce',
  'Good Shepherd School',
  '8c0c8c45-4448-53fa-9a4d-bbb06d80990d',
  'free',
  'Alberta Separate school. Authority: The Holy Family Catholic Separate School Division. Code: 1572'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '97efab2c-d7f7-54b8-97d2-52b9b0dfd21e',
  'Glenmary School',
  '8c0c8c45-4448-53fa-9a4d-bbb06d80990d',
  'free',
  'Alberta Separate school. Authority: The Holy Family Catholic Separate School Division. Code: 1573'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '86cc7eea-47ca-5816-9d00-dfd8aaa46cac',
  'Rosary Roman Catholic Separate School',
  '8c0c8c45-4448-53fa-9a4d-bbb06d80990d',
  'free',
  'Alberta Separate school. Authority: The Holy Family Catholic Separate School Division. Code: 1574'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e9144eac-1832-5f2e-82dc-99fbd6ce6e8a',
  'St. Andrew''s School',
  '8c0c8c45-4448-53fa-9a4d-bbb06d80990d',
  'free',
  'Alberta Separate school. Authority: The Holy Family Catholic Separate School Division. Code: 1670'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd5effb2c-26e6-5082-bb52-70b05c15d966',
  'Ecole Providence School',
  '8c0c8c45-4448-53fa-9a4d-bbb06d80990d',
  'free',
  'Alberta Separate school. Authority: The Holy Family Catholic Separate School Division. Code: 1671'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ca1d88a3-866c-5e44-a211-d16800ead4fd',
  'St. Thomas More',
  '8c0c8c45-4448-53fa-9a4d-bbb06d80990d',
  'free',
  'Alberta Separate school. Authority: The Holy Family Catholic Separate School Division. Code: 2652'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '922f5e6c-97fc-5db5-b1c6-20b0d01f5b5b',
  'Holy Spirit Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 1156'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cebdc222-4606-52fd-bbd1-8daa215158f8',
  'St. John Paul II Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 2034'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '68e47bb9-b520-5f66-8c51-15105da5ebad',
  'St. John XXIII Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 2037'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd56af859-7dee-50d1-b3d6-d9e1c57cb86d',
  'Our Lady of The Angels Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 2038'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e276b682-8dda-57e7-9bd4-18de1630b3d3',
  'Our Lady of Perpetual Help Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 2039'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e222989b-133b-54af-931a-b4e8d9963415',
  'Ecole Pere Kenneth Kearns Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 2040'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9061a7e6-005f-555b-9053-07d946d52268',
  'Archbishop Jordan Catholic High School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 2041'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '53cc2bcf-15d4-563c-b3e3-f30fe06a4027',
  'St. Nicholas Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 2045'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '84f72516-099c-538d-89ac-cc3eb205dd7c',
  'Madonna Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 2046'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b544ff97-11ac-5aaf-817f-b8afe470a75c',
  'St. Theresa Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 2047'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '74b159c4-6d23-5a15-a7fa-24eb9ca59d01',
  'St. Luke Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 2051'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fbf13e82-0f1b-5e48-8e0f-7dbd8c7318a7',
  'Holy Redeemer Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 2053'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6e8e02eb-2ff1-50da-a737-921adddf13eb',
  'St. André Bessette Catholic High School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 2184'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '808c954a-34f8-522a-8ec6-e45aaf597c06',
  'St. Isidore Learning Centre',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 2185'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '550135b1-ea68-5dca-8159-8be34a7e5621',
  'St. Martin''s Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 3670'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5caf0f3c-ef0d-510a-85dd-27e796f980bb',
  'St. Mary''s Catholic High School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 3671'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f8dfaf31-e70b-520b-8385-27caa827c29a',
  'Our Lady of Mount Pleasant Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 4570'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a8af420f-0727-576b-8df9-aa439cf57d4c',
  'St. Patrick Catholic School',
  '9eee816e-7741-5f2d-96b9-c8504839aec4',
  'free',
  'Alberta Separate school. Authority: The Elk Island Catholic Separate School Division. Code: 4571'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '876085c3-c4aa-5e95-b698-d2aacac74053',
  'Holy Redeemer Catholic Junior/Senior High School',
  '0d8f9ea1-7b1c-5304-9196-94a9af1600d6',
  'free',
  'Alberta Separate school. Authority: The Living Waters Catholic Separate School Division. Code: 1132'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '27204246-f74b-5353-9cb2-608f027a3c11',
  'St. Francis of Assisi Catholic Academy',
  '0d8f9ea1-7b1c-5304-9196-94a9af1600d6',
  'free',
  'Alberta Separate school. Authority: The Living Waters Catholic Separate School Division. Code: 1585'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2922c665-9e20-526c-ba41-d95e1546cb78',
  'St. Mary of the Lake',
  '0d8f9ea1-7b1c-5304-9196-94a9af1600d6',
  'free',
  'Alberta Separate school. Authority: The Living Waters Catholic Separate School Division. Code: 1675'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1c1ccccb-925d-52b1-834d-a9cfecf16a13',
  'Vanier Community Catholic School',
  '0d8f9ea1-7b1c-5304-9196-94a9af1600d6',
  'free',
  'Alberta Separate school. Authority: The Living Waters Catholic Separate School Division. Code: 2024'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '13f18e52-0995-597b-ae26-08610763f913',
  'École St. Joseph School',
  '0d8f9ea1-7b1c-5304-9196-94a9af1600d6',
  'free',
  'Alberta Separate school. Authority: The Living Waters Catholic Separate School Division. Code: 2170'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '53481086-2eb5-50ce-9bb7-33f5da5afeac',
  'École St. Mary School',
  '0d8f9ea1-7b1c-5304-9196-94a9af1600d6',
  'free',
  'Alberta Separate school. Authority: The Living Waters Catholic Separate School Division. Code: 2171'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cfee2182-9eac-59da-a140-6173be9e01c2',
  'Across the Waters Outreach',
  '0d8f9ea1-7b1c-5304-9196-94a9af1600d6',
  'free',
  'Alberta Separate school. Authority: The Living Waters Catholic Separate School Division. Code: 2237'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9584933c-8125-5db7-b4c9-25cdfacdef49',
  'École St. Anne School',
  '0d8f9ea1-7b1c-5304-9196-94a9af1600d6',
  'free',
  'Alberta Separate school. Authority: The Living Waters Catholic Separate School Division. Code: 2481'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd77b1d5e-9ebc-587f-bc42-61a4e6cd48f1',
  'St. Gregory Catholic School',
  '40cdd9e1-3f9a-55d2-99fa-004cf411ddf3',
  'free',
  'Alberta Separate school. Authority: The Evergreen Catholic Separate School Division. Code: 1130'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c583ce27-4116-5933-bec2-556d800923df',
  'Holy Spirit Catholic School',
  '40cdd9e1-3f9a-55d2-99fa-004cf411ddf3',
  'free',
  'Alberta Separate school. Authority: The Evergreen Catholic Separate School Division. Code: 1268'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dc229420-0ce0-530b-98e0-b96865311c93',
  'St. Teresa Catholic Learning Centre',
  '40cdd9e1-3f9a-55d2-99fa-004cf411ddf3',
  'free',
  'Alberta Separate school. Authority: The Evergreen Catholic Separate School Division. Code: 1444'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9817f179-087c-5a1e-87b1-bc182c5b292d',
  'St. Peter the Apostle Catholic High School',
  '40cdd9e1-3f9a-55d2-99fa-004cf411ddf3',
  'free',
  'Alberta Separate school. Authority: The Evergreen Catholic Separate School Division. Code: 1684'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4fcf3d2e-3069-52d3-8a17-0b78c0a0d834',
  'St. Teresa Catholic Junior High Learning Centre',
  '40cdd9e1-3f9a-55d2-99fa-004cf411ddf3',
  'free',
  'Alberta Separate school. Authority: The Evergreen Catholic Separate School Division. Code: 1979'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b7692b60-648a-5308-bc62-a184e7d91574',
  'Father Gerard Redmond Community Catholic School',
  '40cdd9e1-3f9a-55d2-99fa-004cf411ddf3',
  'free',
  'Alberta Separate school. Authority: The Evergreen Catholic Separate School Division. Code: 2030'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2e072b4e-d89c-54d9-ab03-562c3cb30a17',
  'St. Joseph Catholic School',
  '40cdd9e1-3f9a-55d2-99fa-004cf411ddf3',
  'free',
  'Alberta Separate school. Authority: The Evergreen Catholic Separate School Division. Code: 2271'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1c8f7510-c284-52e7-bbf6-81b47820312f',
  'St. John Paul II Catholic School',
  '40cdd9e1-3f9a-55d2-99fa-004cf411ddf3',
  'free',
  'Alberta Separate school. Authority: The Evergreen Catholic Separate School Division. Code: 2272'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a5a9d97f-6072-5ea1-bf64-bcb6186360a0',
  'St. Marguerite Catholic School',
  '40cdd9e1-3f9a-55d2-99fa-004cf411ddf3',
  'free',
  'Alberta Separate school. Authority: The Evergreen Catholic Separate School Division. Code: 2273'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'af414b33-c09b-5207-bb7d-94791cb94dc4',
  'St. Thomas Aquinas Catholic School',
  '40cdd9e1-3f9a-55d2-99fa-004cf411ddf3',
  'free',
  'Alberta Separate school. Authority: The Evergreen Catholic Separate School Division. Code: 2274'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '55d4ad25-35f5-52d8-a8e7-c11cafdf388d',
  'St. Mary Catholic School',
  '40cdd9e1-3f9a-55d2-99fa-004cf411ddf3',
  'free',
  'Alberta Separate school. Authority: The Evergreen Catholic Separate School Division. Code: 2471'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c426a9de-cc62-52d0-84b6-2ea2d6a7adee',
  'St. John Bosco',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1024'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8ac699c0-ebe3-5263-85a0-70bebf76fe05',
  'Father Michael Troy Catholic Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1025'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3b6b5812-8d3c-50b0-b107-50c0fcb5c8cf',
  'Archbishop Joseph MacNeil Catholic Elementary/Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1026'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7814daa7-6565-5889-b7aa-705600e318d6',
  'St. Teresa of Calcutta Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1027'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '063d3d8c-1720-5fa1-8ca0-8a535570b924',
  'St. Oscar Romero Catholic High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1028'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ef289a13-1230-57d2-8a3e-f1d5072dd475',
  'Kisiko Awasis Kiskinahamawin at Mountain Cree Camp',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1361'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9e99350d-2990-5601-9315-172a1cbc34b3',
  'Sister Annata Brockman Catholic Elementary/Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1427'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5cf69a2b-acd7-5eb5-a7b7-c160dae450fc',
  'Monsignor William Irwin Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1428'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '711c6c33-08d4-5a08-8f79-9c14e5556e03',
  'Monsignor Fee Otterson Catholic Elementary/Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1429'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '180f53c7-cf93-5b18-bd3f-80c415f139cf',
  'Mother Margaret Mary Catholic High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1430'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '95479f10-0022-50cf-8aeb-b4e2f7e4a111',
  'Alberta Health Services Day Program',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1576'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '27d637d5-8ace-5384-9910-9f1dae573a50',
  'Bishop David Motiuk Catholic Elementary/Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1967'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '06f79284-7e73-5e04-b88f-3ec7e5848ffc',
  'Father Michael Mireau Catholic Elementary/Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1968'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd8db8c61-bcc9-5ae6-8a55-bb39ffdf8d42',
  'St. John XXIII School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1969'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b91a5b2d-3dc9-5e5f-a8d3-195d001f70f0',
  'St. Brendan School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1970'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '18253ef7-18f1-5c2d-8821-044b0d824ee4',
  'St. Thomas Aquinas Catholic Elementary/Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1971'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a13edaac-abaa-5008-b655-ef5a87ef4f73',
  'Christ the King Catholic Elementary/Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1972'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7f0abfd5-d849-5687-bb58-0d6ad351cb6c',
  'Corpus Christi Catholic Elementary/Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 1973'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f5127b57-ad9b-54c7-a6d0-23e85e50cf9c',
  'Divine Mercy Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 2266'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '134fc362-6fa0-53eb-a268-bd2c08f1b65b',
  'Cardinal Collins Catholic Academic Centre - Clareview',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 2382'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7bddd4ac-c45c-53ab-beba-b6340907be5a',
  'Cardinal Collins Catholic Academic Centre - Mill Woods',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 2383'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fad7c817-340b-5ba4-bdbe-715eb3cacd7c',
  'Cardinal Collins Catholic Academic Centre - Westmount',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 2384'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '53d1f318-5f7b-5a51-bb93-dd3b82c20fec',
  'Cardinal Collins Catholic Academic Centre - City Centre',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 2385'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5f3c9a1d-4879-5f58-9722-27e317a98800',
  'Joan Carr Catholic Elementary/Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 2435'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '41d5a0db-2d13-53d3-9052-595992081f58',
  'Father Michael McCaffery Catholic High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 2436'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4b5068c5-8fae-5595-a6ed-6c3a4c3419aa',
  'Annunciation Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8001'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0a2f569c-9b0a-5e4f-b509-ad5bb4bdafbe',
  'Father Leo Green Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8003'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '499a5b5f-6ab3-5a90-8409-7fd1d99b2a4f',
  'H. E. Beriault Catholic Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8004'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0069cebe-87c7-5f69-a105-30c5bfa5ede9',
  'Our Lady of Peace',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8010'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8362cad4-abaf-5eaa-b8f9-686ac5d922d3',
  'Our Lady of Victories',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8011'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9e421af6-42e4-5a11-8299-ff6917a69e5a',
  'St. Angela',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8013'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8752b211-60d6-5232-88fc-fca0f4254600',
  'St. Bernadette',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8016'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a73fa005-0a27-56ee-9ce9-94a4eb30729b',
  'St. Boniface',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8018'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'df60f8ea-feba-549c-a553-15c330c640b3',
  'St. Dominic',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8020'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ec357389-36a9-5f47-aa3d-6f56673fa8fc',
  'St. Gerard',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8022'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2db45b91-b5d5-55f5-bf6d-2a77eacc9b1e',
  'St. Martin',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8028'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'df2b0cf2-b94c-5346-83b3-25710821cd82',
  'St. Matthew',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8029'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'acc51708-41e9-542a-854d-66146002ffd7',
  'St. Stanislaus Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8032'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f6a4bafb-5446-5f7b-a904-0a43a0aaf91e',
  'St. Vladimir Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8034'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '37882a71-6b4d-5cac-a2ef-08c2787d2cec',
  'St. Philip',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8037'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f8eaf1e5-fb84-52fc-8cd1-43cb4054b5da',
  'St. Augustine',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8038'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f6b20182-7756-5160-a541-9bab83b7726b',
  'St. Monica School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8039'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0efb3523-9b9e-5611-a4e4-7f596f1e839c',
  'St. Justin',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8040'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7d3f3b5b-ce5a-54e4-bfb2-becc8392427a',
  'St. Elizabeth',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8041'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '12df6863-7012-50e8-948b-4e22374934e6',
  'St. Anne',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8042'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1451d32c-5285-519e-98ae-379fecc04b70',
  'Katherine Therrien',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8043'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '41c36db3-3a87-565d-8684-0586c30542a8',
  'St. Hilda',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8044'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd58ba2b5-17b1-5132-900a-611dfc895a21',
  'St. Timothy Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8045'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7298ae3b-a702-5a83-950e-8feef0f96278',
  'St. Maria Goretti',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8047'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e3fd3257-3626-50ca-9eb2-110a4205f1ea',
  'Bishop Savaryn Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8048'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '23f4a10f-1dd2-5863-9506-f922d211fcca',
  'Anne Fitzgerald Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8049'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '368eea8c-0682-575e-b931-c8fed8b5247e',
  'St. Martha',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8050'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2701ff80-d613-5908-82f1-3411c83f8363',
  'St. Teresa Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8051'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c5ae0eb9-0107-56f4-94cd-53be04069ceb',
  'Blessed John Paul I Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8053'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd27a1f6a-f3e2-56ea-89a2-d113d92c78a8',
  'St. Bonaventure',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8054'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dca6aded-5efc-5aaf-abe0-7e6f3f2b305b',
  'St. Lucy',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8055'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6fe23fce-f804-537c-975c-e7192d4ec2c0',
  'St. Richard',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8056'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e9b3f4d4-8b93-59ad-ae4f-6ba7d2d353a1',
  'St. Charles',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8057'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4584e474-1704-59e9-8efd-dd9fa3e46e45',
  'Our Lady of The Prairies',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8058'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4ec72e3d-b975-58fa-9e36-e31b87104c22',
  'Bishop Greschuk Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8059'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b0e31c09-8aad-5370-8bb3-31127ae49dea',
  'Mary Hanley',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8060'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'aca23d3f-9d9c-5fb0-944f-69b5740b3670',
  'Good Shepherd Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8061'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4ca6f10c-b52e-5966-bac3-19cd3391584a',
  'J. J. Bowlen Catholic Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8200'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '577aeda7-9ad5-5bbd-9cd9-1b205248525e',
  'Holy Child Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8202'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b8fc9105-dbae-57e5-bb5c-40809799e5dd',
  'Holy Cross Catholic Elementary/Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8203'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '39fb1d89-a88c-50d3-888c-5512f7eea7fb',
  'Our Lady of Mount Carmel',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8205'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0a121af5-f7c0-54e7-86cc-8b35e623a860',
  'Sir John Thompson',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8207'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9ba5277b-848a-522f-8257-0a2745006666',
  'St. Alphonsus',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8208'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3d5a86e6-631e-5a2a-b08d-179d9762f202',
  'St. Catherine',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8212'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd072a2b2-8055-53dc-88fd-01de0adb8491',
  'St. Cecilia',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8213'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '97e70b7c-81d6-5538-b44e-11d9275b12ec',
  'Ben Calf Robe - St. Clare Catholic Elementary/Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8214'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f7c20714-c578-5e56-9563-d4792c7d8e3e',
  'St. Edmund',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8215'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e221f4cf-f9f4-5f28-9991-5261e41c5b25',
  'St. Francis of Assisi',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8216'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd7f090a5-7b67-5522-b0c5-1d25d5dccadf',
  'St. Gabriel',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8217'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8f7be74e-c50f-507e-a517-caf3cdeb1599',
  'St. Leo',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8220'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '40c4254b-4eb8-5a93-a3c9-374f1e8bbe8f',
  'St. Mark',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8221'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4a6b13af-ca7a-55c1-a842-106ed2655182',
  'St. Nicholas',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8223'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '913fa889-40d0-5ae3-9254-906c91bf5092',
  'St. Paul',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8225'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2645b3b4-c0ef-564f-860e-d5c32e50694e',
  'St. Pius X',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8226'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c3c0ebd0-1346-5669-bf94-e7033fa17a9e',
  'St. Rose Catholic Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8227'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c45c3f39-d584-53ce-94a9-32074aa544b4',
  'St. Thomas More Catholic Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8228'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '149433c3-94d4-53da-9daa-21ff2c2493a7',
  'St. Vincent Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8229'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '978558fa-2dd0-5454-9d78-00cea86f0e30',
  'St. Elizabeth Seton',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8230'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9fbbb4ee-3088-511e-8f33-3a60ff5445c3',
  'St. Clement',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8231'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0e58bfb0-17d8-5a67-b6db-e17aed8cb9dc',
  'St. Benedict',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8232'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a67623ce-26e0-5102-bc7a-6de9ec1481be',
  'Holy Family Catholic Elementary/Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8234'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '73d45ac7-755a-5696-a3e3-83fd3fc3daba',
  'Frere Antoine Catholic Elementary School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8236'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5773a172-069e-5ecb-a6fe-8e10aaa4beec',
  'St. Mary',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8237'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '22e3a475-7cd6-5816-9948-b70fcab978ef',
  'St. Kateri Catholic School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8238'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a60b6c8e-4a3c-5a7e-b187-7e2508649d03',
  'Cardinal Leger Catholic Junior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8287'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b857e17a-58ac-58e8-9cbe-049f648f0a7b',
  'Austin O’Brien Catholic High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8402'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8b047148-5898-5caf-9ff9-e844bf7519b0',
  'Archbishop MacDonald Catholic High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8403'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8be16028-fa6a-5846-8f81-46dc5f6a707b',
  'Archbishop O’Leary Catholic High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8404'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a9e22c34-ae0b-5c19-9f1b-81417b265480',
  'St. Francis Xavier',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8405'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c89ebf66-f7c4-5f34-98d5-bd789d9ced4f',
  'St. Joseph',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8407'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '70dbbfb4-5c00-5686-b12b-7ca15c948ce7',
  'Louis St. Laurent',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8409'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '67f33cff-a226-5a80-ab46-0680c5f064b3',
  'J. H. Picard Catholic Elementary/Junior/Senior High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8410'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2a4b86b9-08ca-5c34-9b3c-c0be5ddcb913',
  'Holy Trinity Catholic High School',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8411'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f540592b-172c-5f24-84df-c4d9e22f27c7',
  'Alternative Education',
  'e23acf3a-35ff-5675-a211-6b21fb0fb474',
  'free',
  'Alberta Separate school. Authority: The Edmonton Catholic Separate School Division. Code: 8412'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f8610e63-9bce-57e8-a5e4-ee66adfc6dc9',
  'Monsignor J. S. Smith School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 0313'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7aab36cf-0e6d-514e-aa4a-f39283d45fa0',
  'Ascension of Our Lord',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 0333'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b08a0ce5-a78e-5712-bd23-7df3bcbbd62a',
  'St. Martin De Porres High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 0346'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b19f1ce6-f871-501c-ad56-120fd00e95ae',
  'Holy Angels School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 0389'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fbd7abc2-8768-52cb-8bd8-4c6f634e87e0',
  'St. Ambrose School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 0390'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bb9670bd-6dfb-5348-ba71-5ab72ad97d88',
  'Bishop O''Byrne High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 0581'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ac048d50-cdb7-5124-abaf-bf0e6ec8233e',
  'St. Elizabeth Seton',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 0588'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '13554c4e-0a89-5b71-b1fc-80eb168191c2',
  'Monsignor J. J. O''Brien',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 0589'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7f95742a-5a8d-595d-97cb-cb2b7721dbac',
  'Our Lady of Lourdes',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 0598'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c7042515-f87a-5f75-9837-0b524a180b73',
  'St. Gabriel the Archangel',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1029'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3365f6ac-3b38-5731-bfc2-d236a355d7f8',
  'St. Clare',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1118'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5099c0d3-060a-5104-97f1-d2171518ed0a',
  'St. Brigid',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1119'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8c1412f5-551e-5ede-8b39-07bde1bfbaab',
  'St. Timothy',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1225'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4f18d365-90f5-5bb7-9c9f-26c7ec6f0b0b',
  'Our Lady of Fatima',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1226'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '49bd7b26-4a0b-5e71-b67e-15f7d0efe3ce',
  'Notre Dame High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1275'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f0eaca92-d3c8-5ad9-b43c-c30811a88937',
  'St. Albert the Great',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1336'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9647bf6c-cd7a-5f62-b3af-1a276c116886',
  'St. Basil Elementary/Junior High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1337'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4f878e43-cd67-57c3-9501-ad5b5a193a85',
  'St. Joan of Arc Elementary/Junior High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1338'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '42e21051-f9de-5b86-bf9e-226751833ca2',
  'St. Sebastian Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1339'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '05cd0504-c35b-50a1-9728-698d9bdd0489',
  'St. Jerome Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1340'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c287a963-3bb1-5cce-a30d-14e3c26ee9f3',
  'Our Lady of Wisdom',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1373'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a2e2206d-b9b3-581b-a1a0-2b6e6f782df2',
  'Good Shepherd School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1462'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '69febc74-0868-5ad0-849e-df7e618486fa',
  'Christ the King Catholic School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1484'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '928d3ec1-948d-573b-a5d7-2848fb3dd68f',
  'Our Lady of the Evergreens Catholic School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1485'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '54197e4e-bf34-5e51-87cd-ea9fc8fee532',
  'Light of Christ Catholic School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1486'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '61c03d25-fe06-5351-be01-a755f68d21b4',
  'Fresh Start Outreach Program',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1525'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '193dd993-82a6-5ed0-9b67-5c2270f3d6a6',
  'St. Isabella School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1680'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7ec24c74-c6d4-5185-84fc-e13345fd0c0e',
  'Junior High Fresh Start Outreach Program',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 1688'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '13fd5f55-d927-5e82-bc42-91a0b4cb9d98',
  'Prince of Peace School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2080'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '13feeefc-108c-5121-b7ef-1e04b1dd374c',
  'Our Lady of the Rosary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2081'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ca08bc25-57a1-5090-a74c-b9ac592a62ab',
  'St. Marguerite School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2082'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f0058f66-ac18-501a-8301-70000e16a9f3',
  'Our Lady of Grace School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2083'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5adf2968-e4d7-5488-b974-0f3fb826f9cf',
  'Apostles of Jesus',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2155'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a9f44e3e-5422-575f-837c-6fddd9797153',
  'Guardian Angel School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2156'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5ba29a98-9c15-512a-915f-140b7cfb9ee5',
  'Holy Child School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2160'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e9199652-0397-5fea-a07b-051daf5b9857',
  'All Saints School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2175'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '87e587a6-c0ee-529c-a222-a95cadf4b909',
  'Divine Mercy School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2189'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0ca95434-7c5a-5464-9da4-bd1947458009',
  'Blessed Marie-Rose',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2195'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '56472b39-f5e5-5634-9b1a-6d2ae5c62881',
  'St. Veronica School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2259'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd15466e1-4775-5a5d-940b-05aa092d9505',
  'St. Gianna School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2328'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ca2ddb83-c6aa-5da6-a25a-3f8651987bd2',
  'St. Isidore Online School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2344'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '595339cf-ddd8-55c7-bdd1-6c71466bd31e',
  'St. Josephine Bakhita School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2355'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bd837547-1ad8-52dc-8d7c-023bf3cdc014',
  'Holy Spirit School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2438'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9caa2c0f-10ec-57db-b9ab-005c7a36a5e7',
  'St. Gemma Outreach High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 2489'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '186595e9-2cec-5c0c-b94e-20568b4539f4',
  'Our Lady Queen of Peace Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 5270'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '25295ad1-cdcb-519a-b333-5ffa06c4bd3e',
  'Corpus Christi School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8501'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd0c6b9f3-8602-53af-90a8-46aae1eeabb5',
  'St. Hubert Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8502'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a28384a2-21aa-5dea-a010-e054ff9d7f98',
  'Holy Family School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8503'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5e5fc355-93b4-5650-a5d2-6a6b9e2bac7e',
  'Holy Name (Bilingual) School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8504'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '16f84810-3d51-57d3-b3a8-e4429edb105f',
  'Holy Trinity School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8506'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '213a5862-4a25-5fd0-8cda-b271817c624f',
  'St. Patrick School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8507'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cab19321-c9e2-5001-998e-4dae429e8313',
  'St. Andrew School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8508'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9839e424-da05-58a0-9d2e-9d3c8c067c6d',
  'St. Benedict School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8511'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5be85b36-b8f7-5f87-9fe7-1e60e87a44ba',
  'St. Cecilia (Bilingual) Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8513'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '39442c8c-99fa-5d44-b8e0-858662a42f98',
  'St. Anthony',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8515'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2fa0d510-d0cf-5835-85c4-65aea7432a85',
  'St. Luke Bilingual Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8521'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f02e8a38-d122-57c8-a0db-87ca148df210',
  'Ecole St. Pius X School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8524'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '91df6f38-e2a4-5d11-b7eb-d213b4325cfb',
  'St. Thomas Aquinas School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8527'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '09cdde60-31d8-540a-8256-a34cba2564ad',
  'St. Vincent De Paul Elementary Junior High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8528'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '92940dde-fa39-5c75-ae94-3d627ae1c194',
  'St. William School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8529'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '70045f8f-4eb0-5a7d-99e1-ce947094179d',
  'St. Monica School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8530'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '44b9bd18-1063-520b-a0d3-0cee5f7ebe56',
  'St. Dominic School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8531'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4ef593fd-8bca-5873-924d-49d04d3ccd92',
  'St. Boniface Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8532'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9332ee48-f778-534b-9237-de601c2e1fce',
  'St. Catherine Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8533'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '205b763b-cfdd-515d-98a2-946baeb1c5d3',
  'St. Henry Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8534'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '370858f8-ed2f-5da8-ad1d-e0969af93e2c',
  'St. Mark Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8536'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5e7991e5-3f7b-5d58-8485-e50258459625',
  'St. Sylvester School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8537'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'eb6724e0-f1be-5c2c-b83f-c03a288ef16f',
  'St. Wilfrid Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8541'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0f330f9b-3879-5e01-b8ec-7cf5edb879f9',
  'St. Teresa of Calcutta School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8542'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '729d4690-fbdb-57bc-a932-0ec12451236f',
  'St. Peter Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8543'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4127ac4b-fd5d-548f-aa46-cc38bb3ee8d0',
  'St. Thomas More School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8544'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '470c6b6a-d994-5c7c-967d-a4bf3adc4633',
  'St. Bede Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8545'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '55770d0a-76a4-5b7f-b6fb-bac280971dde',
  'St. Jude School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8546'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7becbc9a-5a48-5716-9aa1-7024cc1c0045',
  'St. Rita School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8547'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '081fd18d-b971-523e-809d-21931dafcd3f',
  'St. Rupert School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8548'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '07c86299-a6cd-522d-9905-ee9827477262',
  'St. John Paul II School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8549'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a1f67aa5-55f1-5e5d-a8c0-267d00e8380f',
  'St. Damien School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8550'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f7b5dcdc-5b80-5508-a357-eb69bb07dd94',
  'Father Doucet School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8551'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '16e01ab6-402d-58f2-8c6e-b85137462bd2',
  'St. Kateri Tekakwitha School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8552'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e9f340b8-b1e2-5d85-b30b-bbc7b870b8f1',
  'Mother Mary Greene School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8553'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd37850fd-0110-50ac-ac73-c9552badb116',
  'Monsignor Neville Anderson School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8554'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a19e4cfc-2512-5494-8973-c513a6b14940',
  'Monsignor E. L. Doyle Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8555'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '07145ea9-7181-5101-99a9-25bf8ceb113b',
  'St. Maria Goretti Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8556'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1741f705-1fb4-578e-abf9-691ea8d4ea69',
  'Monsignor A. J. Hetherington Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8557'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '25e86b93-bbab-5186-90b8-d00d159f7749',
  'John Costello Catholic School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8558'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c0b62b5d-81cb-5ee6-b3fa-c62e106965be',
  'Our Lady of the Assumption School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8701'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2a358643-9d50-5fd6-aa1e-9d9be4e8ae99',
  'Bishop Kidd School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8702'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'db68064f-b97a-5284-9247-9182aa44cf0d',
  'St. Jean Brebeuf School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8703'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '90c1f825-b223-507d-9502-cb50ed7fa15e',
  'Holy Cross Elementary Junior High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8704'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '99b30d4a-8676-5eab-b26a-e6c70c6321ad',
  'Sacred Heart Elementary School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8705'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '18c1e694-dbe5-57e6-b7e4-2d0be3df4a40',
  'St. Alphonsus Elementary Junior High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8706'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '749e277e-ec2c-5775-b0e1-c33b3609ee67',
  'St. Augustine Elementary Junior High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8708'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '733c6138-4455-51e8-bc80-a752553eb00a',
  'St. Bernadette School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8709'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3b797ddf-65b4-55f7-8764-d8fe91630813',
  'St. Gregory School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8710'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3cdf94eb-0808-5b36-918d-6145655c79c6',
  'St. Helena School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8711'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '432787a9-0f1d-5cb8-a7df-4f7c25de24fe',
  'St. James Elementary Junior High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8712'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e4230685-7862-5416-9242-e773f368693d',
  'St. Joseph Elementary Junior High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8713'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5bea0111-5cc7-5b3b-a790-6c2478298523',
  'St. Margaret School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8714'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2bed1160-287a-5132-a4b4-6e1e256290c2',
  'St. Matthew School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8716'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '597250d8-cd72-5a65-bd89-224b0e0085d2',
  'St. Michael School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8717'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '60bbcbaf-f73e-5582-8891-9f06bf55c69b',
  'St. Stephen School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8719'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '93109c8d-78da-576b-ae38-ba15a035f71a',
  'St. Bonaventure School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8721'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '54e3204c-639b-503d-a8ec-ffd56f008b9e',
  'St. Rose of Lima Junior High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8722'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5470ae63-de1c-57fa-b7a2-ad7fdfca2e11',
  'St. Cyril School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8723'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7dafb0ce-edf3-5066-98d4-2d1ac3bab847',
  'St. Philip School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8724'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '546630c6-3df3-5ce0-93f7-d68fcc448ba4',
  'St. Martha School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8725'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1460da0f-238b-5f2e-b3d1-5a713954226f',
  'St. John XXIII School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8726'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a5af9a2b-b776-59b1-86b4-16c041424e4e',
  'Don Bosco School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8727'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'df720a7e-d97b-56b7-a9d8-dea10c9308e9',
  'Madeleine D'' Houet Bilingual School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8728'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd04cb65a-7b52-502e-87f3-275335ea196b',
  'Father James Whelihan',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8729'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bddbc529-0328-56e1-95db-b6740719d709',
  'Father Scollen School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8730'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0ae92a06-5deb-5d72-8671-f05286ca7b5d',
  'St. John Henry Newman School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8731'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8b042d0b-d7a2-50d5-b46b-aaf82e50b98f',
  'Our Lady of Peace Elementary Junior High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8732'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6b50bc21-4a36-5c1e-a54a-06fe37e82793',
  'Our Lady of the Rockies High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8901'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd4fcfb71-d63e-56f1-bb0a-5c90ee73f95c',
  'St. Francis High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8902'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ca81ad5a-cf3c-5d3e-8613-67a8d53f4e6f',
  'Father Lacombe School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8903'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f60d881e-2e69-518a-908b-a8abe5109937',
  'St. Mary''s High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8904'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '13b61b05-1ff4-55fc-846e-51523313aab1',
  'Bishop Carroll High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8905'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a4fe017b-dbf2-5868-8410-c763d91c14a5',
  'St. Anne Academic Centre',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8906'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9b81c2df-5bd3-5e40-bf15-21f1c74a0da5',
  'Bishop McNally High School',
  '5fe79022-2f52-5d19-8bcc-12aa1c6ca120',
  'free',
  'Alberta Separate school. Authority: The Calgary Roman Catholic Separate School Division. Code: 8907'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b1e2596e-4070-58dc-94e4-d9aedcdd6553',
  'J. J. Nearing Catholic Elementary School',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 0338'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b487d15f-7908-5d27-8f7d-476b6e59cdfe',
  'St. Gabriel Education Centre',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 0378'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0930f46e-c1a1-5717-8f5b-1f5bbc27460b',
  'St. Kateri Tekakwitha Academy',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2186'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'deedc886-488b-5856-84f6-2586b5eb1f56',
  'Sister Alphonse Academy',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2187'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '112b8b99-26c7-519b-97a1-ffdd7fc32fe2',
  'Legal School',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2535'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0a9b87d7-9a95-5cb4-8a02-cb3128d932a6',
  'Notre Dame Elementary School',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2571'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0f6ee515-c3df-50e0-b11a-1eb8f734c810',
  'Georges H Primeau School',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2572'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '849c99e0-06c8-58a2-8f5e-dba6a08ca435',
  'Albert Lacombe Catholic Elementary School',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2575'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '31ea5e77-f11a-553b-82a3-f7315afb552e',
  'École Secondaire St. Albert Catholic High School',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2577'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '65ab7c15-795d-59e2-8b7f-7055eebdd135',
  'Holy Family Catholic School',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2578'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6bcbf765-f149-59d1-88f1-3837e82a8957',
  'Vincent J Maloney Catholic School',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2579'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '19a70e25-3be3-5f13-80e5-34d3445a43bd',
  'Bertha Kennedy Catholic Community School',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2580'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd9dd4941-6a52-510a-9e83-666b1932c03e',
  'Neil M Ross Catholic School',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2584'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f66dd10b-ceb8-513f-80d1-5981a2ba4b72',
  'Ecole Secondaire Sainte Marguerite d''Youville',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2587'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cbcca508-5de7-50f5-a210-ca043feb559c',
  'École Sacré-Coeur',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2588'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd827e3e9-24f7-5693-9fa5-6e17665164a4',
  'Richard S Fowler Catholic Junior High School',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2589'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '22ec7ddc-a6d1-5c88-a88c-048af3655111',
  'Morinville Community High School',
  'a7fe4422-5c5e-5ad9-86ce-be29796a55f5',
  'free',
  'Alberta Separate school. Authority: The Greater St. Albert Roman Catholic Separate School Division. Code: 2594'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f3313c09-9e03-5186-934f-1c64135c39ab',
  'Holy Family Catholic School',
  '43bee489-ff3a-5d6f-a7e7-4f03cd8455c0',
  'free',
  'Alberta Separate school. Authority: The Lakeland Roman Catholic Separate School Division. Code: 1121'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'af9a452d-0b08-5a98-84c7-402d14110547',
  'Light of Christ Catholic School',
  '43bee489-ff3a-5d6f-a7e7-4f03cd8455c0',
  'free',
  'Alberta Separate school. Authority: The Lakeland Roman Catholic Separate School Division. Code: 2124'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9c2693c7-9a80-5b88-ac42-c52ca00ef7eb',
  'St. Dominic School',
  '43bee489-ff3a-5d6f-a7e7-4f03cd8455c0',
  'free',
  'Alberta Separate school. Authority: The Lakeland Roman Catholic Separate School Division. Code: 2970'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '68c7b2c7-0732-54b0-b0c8-a98b853c2258',
  'Assumption Junior Senior High School',
  '43bee489-ff3a-5d6f-a7e7-4f03cd8455c0',
  'free',
  'Alberta Separate school. Authority: The Lakeland Roman Catholic Separate School Division. Code: 2971'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1a7b2c03-9f17-53d0-a538-382ba077e98f',
  'Ecole Notre Dame High',
  '43bee489-ff3a-5d6f-a7e7-4f03cd8455c0',
  'free',
  'Alberta Separate school. Authority: The Lakeland Roman Catholic Separate School Division. Code: 2973'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a6001678-9b3a-5df6-9d90-2257ded8e8bb',
  'Notre Dame Elementary School',
  '43bee489-ff3a-5d6f-a7e7-4f03cd8455c0',
  'free',
  'Alberta Separate school. Authority: The Lakeland Roman Catholic Separate School Division. Code: 2974'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c4779520-cbc1-545a-99fd-93e94eb6eac0',
  'Ecole Dr Bernard Brosseau School',
  '43bee489-ff3a-5d6f-a7e7-4f03cd8455c0',
  'free',
  'Alberta Separate school. Authority: The Lakeland Roman Catholic Separate School Division. Code: 2976'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0c3348bb-f9d6-5c33-bbe8-11383cb72a36',
  'Holy Cross Elementary School',
  '43bee489-ff3a-5d6f-a7e7-4f03cd8455c0',
  'free',
  'Alberta Separate school. Authority: The Lakeland Roman Catholic Separate School Division. Code: 2994'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7ec68253-fa9e-59c4-8d31-c635a6461f58',
  'St. John Bosco Catholic School',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 1138'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7eb77e4c-de92-5691-9d01-4c04818f18e4',
  'St. Mary Catholic School',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 1170'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b2c90343-9285-5aad-8d5f-ab951bf6e113',
  'St. Mary''s Catholic School',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 1171'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '34a11e73-386a-55bc-8cfc-af7768a4d7bb',
  'Holy Cross Catholic School',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 1172'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6b1ff724-28bb-5163-adf5-83c8223b74cc',
  'St. Clement Catholic School',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 1176'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '119e0f2f-487e-5f1a-a71a-e0d8b2bf5fee',
  'St. Joseph Catholic High School',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 1178'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '30ce6596-be3e-5d87-8a79-cc26a00cb2a0',
  'St. Patrick Catholic School',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 1179'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ddfa8ca5-d036-52af-bbb6-4ed02d33ae19',
  'Ecole St. Gerard Catholic School',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 1180'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3b634b3e-7f06-5ddb-b631-fe5917a3d851',
  'St. Kateri Catholic School',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 1181'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '27170d95-358e-5326-b829-3ba09e86f1b4',
  'Ste. Marie Catholic School',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 1370'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '985f394b-3ccf-50ff-a6bd-d0c1f13235bf',
  'Mother Teresa School',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 1454'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a02dc5a3-0771-59cb-9361-0ee564555ebb',
  'St. Catherine Catholic School',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 1955'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e03b9ba6-1b80-5b5f-bb82-92253501aec3',
  'St. John Paul II Catholic School / Faculté St. Jean-Paul II',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 2157'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '22e56cc3-fa1e-5e2b-972f-e874ef3b08f9',
  'École Catholique Louis Riel',
  'e33b0bbf-23d2-5136-9407-c3dcfa5d4c75',
  'free',
  'Alberta Separate school. Authority: The Grande Prairie Roman Catholic Separate School Division. Code: 2437'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c2f7d412-ba28-59d8-be59-f278dd79db58',
  'St. Martha Catholic School',
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'free',
  'Alberta Separate school. Authority: The Fort McMurray Roman Catholic Separate School Division. Code: 1354'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'be5cb916-02eb-56a8-83fd-da1f2708cf69',
  'Holy Trinity High School',
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'free',
  'Alberta Separate school. Authority: The Fort McMurray Roman Catholic Separate School Division. Code: 1564'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7b8e8122-ae34-5d09-935b-fcd83b207eed',
  'St. Kateri School',
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'free',
  'Alberta Separate school. Authority: The Fort McMurray Roman Catholic Separate School Division. Code: 1767'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '02916ed4-92ee-5f0d-9359-620af3706a97',
  'Sister Mary Phillps Elementary School',
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'free',
  'Alberta Separate school. Authority: The Fort McMurray Roman Catholic Separate School Division. Code: 1866'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7cfdcf29-6191-5095-b548-5b7477a138ba',
  'Our Lady of the Rivers Catholic School',
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'free',
  'Alberta Separate school. Authority: The Fort McMurray Roman Catholic Separate School Division. Code: 1871'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5d9ba25f-b9fd-5628-8fe7-fc537d3acdc1',
  'Good Shepherd Community School',
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'free',
  'Alberta Separate school. Authority: The Fort McMurray Roman Catholic Separate School Division. Code: 1872'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '31ca40f6-6e76-5a3c-af90-74813131e97d',
  'St. Paul''s Elementary School',
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'free',
  'Alberta Separate school. Authority: The Fort McMurray Roman Catholic Separate School Division. Code: 1873'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '96650cb9-3d9b-553b-bc62-d967006541bf',
  'Fr M Beauregard Education Community Centre',
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'free',
  'Alberta Separate school. Authority: The Fort McMurray Roman Catholic Separate School Division. Code: 1885'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '68299a34-fafd-590a-9fd0-6113c4ad1614',
  'St. Gabriel School',
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'free',
  'Alberta Separate school. Authority: The Fort McMurray Roman Catholic Separate School Division. Code: 1890'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c79fdb7d-8679-5b1f-95aa-ff571cb4dbf3',
  'St. Anne School',
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'free',
  'Alberta Separate school. Authority: The Fort McMurray Roman Catholic Separate School Division. Code: 1894'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '811bdc2f-a849-546b-80a5-6856c9a7ff0d',
  'Father Patrick Mercredi Community School',
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'free',
  'Alberta Separate school. Authority: The Fort McMurray Roman Catholic Separate School Division. Code: 1899'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b7271adf-93be-57a9-b3e5-e00476e6757e',
  'Elsie Yanik Catholic School',
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'free',
  'Alberta Separate school. Authority: The Fort McMurray Roman Catholic Separate School Division. Code: 2199'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7f9fc844-1cca-589d-acb0-dc0d753fcd6b',
  'Immaculate Heart of Mary Catholic School',
  'ab859e51-c911-5723-bb2c-bff458f29d47',
  'free',
  'Alberta Separate school. Authority: The Fort McMurray Roman Catholic Separate School Division. Code: 2388'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '82a8bf34-b403-532b-b668-c3f004484d76',
  'St. Mary''s School',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 0391'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6bccfaf3-2c31-5b49-92b2-c56cb9e3da05',
  'St. Joseph''s Collegiate',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 0439'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ff0f65dc-2bdf-590c-be39-f12cf8a38a46',
  'Notre Dame Collegiate',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 0519'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4a6e2f0a-2ca9-5d07-9eef-c45131709f2f',
  'Sacred Heart Academy',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 0593'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bfe1e054-2c26-53b9-9a4e-24502b1b8797',
  'Our Lady of the Snows Catholic Academy',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 0594'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6a76047d-3530-5c89-8ba4-ca67ac8346c8',
  'Holy Cross Collegiate',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 1231'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8975ebae-06af-5b30-a6cc-31ac57caa4d8',
  'St. John Paul II Collegiate',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 1281'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '975fda80-8b4a-5f06-ace0-801bc7d0bf04',
  'St. Luke''s Outreach Centre Okotoks',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 1375'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ee5c08a4-7c31-5b4c-aee1-9d49bb14df2e',
  'St. Luke''s Outreach Centre Brooks',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 1431'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5d1bad74-97de-5d00-b972-245f213c8e0e',
  'St. Luke''s Outreach Centre High River',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 1471'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1d0f13b1-e813-5c1d-a734-b82c5d99d351',
  'Okotoks Home Schooling',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 1482'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '69626fe4-ab19-564f-ab30-cd0d63a00e00',
  'Christ The King Academy',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 1784'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8202ce59-050e-5868-8991-5c772f363c25',
  'St. Francis of Assisi Academy',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 2063'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e93ee4fd-810a-57bb-868f-5760ed2b23cd',
  'École Good Shepherd School',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 5370'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '472ff590-474b-5107-91db-6576fbde2fd8',
  'Holy Trinity Academy',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 5371'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c689388e-fb69-55d0-a63b-9b0dc815e681',
  'The Centre for Learning@HOME',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 5372'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bc0cf690-01be-59cc-8c97-c337432fd7f9',
  'Holy Spirit Academy',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 5373'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c34617e6-02fe-5cd5-8201-8ca66925c711',
  'Holy Family Academy',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 5374'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cc97b08a-3595-5f66-9ab9-59624bc4d49c',
  'St. Anthony''s School',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 5770'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '422587e6-a014-55f6-a516-123ac885e54c',
  'Assumption Roman Catholic School',
  '62d931f0-f3ee-52f9-8f4d-02f14d77e43c',
  'free',
  'Alberta Separate school. Authority: The Christ the Redeemer Catholic Separate School Division. Code: 5970'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '29aba6a3-dd75-59b2-b5e5-2732fddf89c1',
  'Blessed Sacrament Outreach School',
  '605d1dfd-ed06-5b4c-8472-1340e9ca561b',
  'free',
  'Alberta Separate school. Authority: The East Central Alberta Catholic Separate School Division. Code: 0433'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5fd2f00a-bf4f-5b5f-82ac-7bbd73383c05',
  'Christ-King Catholic School',
  '605d1dfd-ed06-5b4c-8472-1340e9ca561b',
  'free',
  'Alberta Separate school. Authority: The East Central Alberta Catholic Separate School Division. Code: 1165'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6382ef5d-a9b5-58c5-9886-9b859e1f247e',
  'St. Jerome''s School',
  '605d1dfd-ed06-5b4c-8472-1340e9ca561b',
  'free',
  'Alberta Separate school. Authority: The East Central Alberta Catholic Separate School Division. Code: 3870'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4b7decaa-87e1-51d4-bc1f-02740d556147',
  'Blessed Sacrament School',
  '605d1dfd-ed06-5b4c-8472-1340e9ca561b',
  'free',
  'Alberta Separate school. Authority: The East Central Alberta Catholic Separate School Division. Code: 3970'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fa67ad5e-a8db-5bd8-872d-fb890debb5df',
  'Hope Home Schooling',
  '605d1dfd-ed06-5b4c-8472-1340e9ca561b',
  'free',
  'Alberta Separate school. Authority: The East Central Alberta Catholic Separate School Division. Code: 3971'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3ea48303-e279-5f1c-a6e0-41761dba4ca4',
  'School of Hope',
  '605d1dfd-ed06-5b4c-8472-1340e9ca561b',
  'free',
  'Alberta Separate school. Authority: The East Central Alberta Catholic Separate School Division. Code: 3972'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3d942a1e-a541-5205-81e2-c6c89400f6bd',
  'Theresetta Roman Catholic Separate School',
  '605d1dfd-ed06-5b4c-8472-1340e9ca561b',
  'free',
  'Alberta Separate school. Authority: The East Central Alberta Catholic Separate School Division. Code: 4870'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6d3d11cd-5e73-597c-9857-27bfe231aa4f',
  'St. Thomas Aquinas School',
  '605d1dfd-ed06-5b4c-8472-1340e9ca561b',
  'free',
  'Alberta Separate school. Authority: The East Central Alberta Catholic Separate School Division. Code: 4970'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'caccfc42-4bcb-56ff-b5ee-5a324a97bd2d',
  'Trinity Learning Centre',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 0020'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8f41e634-03ef-5882-bc12-640a5b0f7645',
  'CARE (Centre for Adolescent Responsibility Education) Outreach',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 1400'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7563194d-75cb-5ffa-bc5d-9b3480758468',
  'St. Teresa of Calcutta School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 2062'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ab9be4fb-f4ef-5bdb-9246-cda8aaaf8cff',
  'St. Michael''s School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6170'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '240cd402-c3b4-5446-ab05-3acec90ab691',
  'St. Joseph''s School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6470'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f4a26b25-60e4-5255-ae21-d6e135a3786d',
  'St. Catherine''s School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6471'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '56668333-204f-5b23-8eb6-a0894779e964',
  'Our Lady of The Assumption School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6475'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '36cf6c49-aa23-5296-b516-2db1e2ed97bb',
  'Catholic Central High School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6476'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '64736209-4a12-5cd4-be5c-71e87b2b5696',
  'Ecole St. Mary School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6478'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ba9b8482-7e0f-5f0c-83c0-14d00972516c',
  'St. Patrick Fine Arts Elementary School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6479'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '82def232-c502-51e0-b2a7-492dbd38d62a',
  'St. Paul Elementary School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6480'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5dcfc873-a11b-5ded-85c6-32e14ca1ef11',
  'St. Francis Junior High School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6481'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2514ad95-5201-58fd-b72a-33bd6f73761a',
  'Children of St. Martha School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6482'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd84e6d84-d40b-5b24-b2fc-6e6d5f8da7ff',
  'Father Leonard Van Tighem School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6483'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b7b1299b-464d-5c99-bbba-26337104bcc1',
  'St. Mary''s Roman Catholic Separate School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6670'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '077c4ffc-7ad2-5a1b-9dc0-cfcd2f62623b',
  'St. Patrick''s Roman Catholic Separate School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6671'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b5b12d6e-ffc9-5d03-9d33-ea8c787e7dd7',
  'St. Michaels School',
  '2fe5e53a-7202-5c0d-a961-918aba5136b3',
  'free',
  'Alberta Separate school. Authority: The Holy Spirit Roman Catholic Separate School Division. Code: 6970'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '89b1b553-d3eb-5abe-ad40-04d4661afc8e',
  'Notre Dame Academy',
  'b8291d77-a15a-5663-8b1e-307b690c1c64',
  'free',
  'Alberta Separate school. Authority: The Medicine Hat Roman Catholic Separate School Division. Code: 1229'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '92252431-8d6f-5dd4-89b2-4b2bc8e531d6',
  'École St. John Paul II School',
  'b8291d77-a15a-5663-8b1e-307b690c1c64',
  'free',
  'Alberta Separate school. Authority: The Medicine Hat Roman Catholic Separate School Division. Code: 2197'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '90a0b52d-ef5f-5de1-a0dc-4b6fe399d591',
  'St. Joseph’s Education Centre',
  'b8291d77-a15a-5663-8b1e-307b690c1c64',
  'free',
  'Alberta Separate school. Authority: The Medicine Hat Roman Catholic Separate School Division. Code: 2391'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bfeebfd0-cccf-539e-b10d-21ff3e3449c9',
  'St. Nicholas Early Learning School',
  'b8291d77-a15a-5663-8b1e-307b690c1c64',
  'free',
  'Alberta Separate school. Authority: The Medicine Hat Roman Catholic Separate School Division. Code: 2626'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '36e46912-e4cb-5a51-8ced-e75c9554a719',
  'Monsignor McCoy High School',
  'b8291d77-a15a-5663-8b1e-307b690c1c64',
  'free',
  'Alberta Separate school. Authority: The Medicine Hat Roman Catholic Separate School Division. Code: 6870'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3d09b75d-ecc2-5c64-8a18-09a3b516763a',
  'St. Francis Xavier School',
  'b8291d77-a15a-5663-8b1e-307b690c1c64',
  'free',
  'Alberta Separate school. Authority: The Medicine Hat Roman Catholic Separate School Division. Code: 6871'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c136aa38-aefa-551c-8871-73f4c686849c',
  'St. Louis School',
  'b8291d77-a15a-5663-8b1e-307b690c1c64',
  'free',
  'Alberta Separate school. Authority: The Medicine Hat Roman Catholic Separate School Division. Code: 6872'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '50dfc9cf-5ef0-5398-8019-2a5e30c55fd7',
  'St. Mary''s School',
  'b8291d77-a15a-5663-8b1e-307b690c1c64',
  'free',
  'Alberta Separate school. Authority: The Medicine Hat Roman Catholic Separate School Division. Code: 6873'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c356ae5e-a18a-5a70-892a-e34d755b28ee',
  'St. Michael''s School',
  'b8291d77-a15a-5663-8b1e-307b690c1c64',
  'free',
  'Alberta Separate school. Authority: The Medicine Hat Roman Catholic Separate School Division. Code: 6874'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '62224642-c9eb-5de6-af1b-5e8976ee459c',
  'St. Patrick''s School',
  'b8291d77-a15a-5663-8b1e-307b690c1c64',
  'free',
  'Alberta Separate school. Authority: The Medicine Hat Roman Catholic Separate School Division. Code: 6875'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '37fa5108-4af3-5342-9cd9-585fbae868cd',
  'Mother Teresa School',
  'b8291d77-a15a-5663-8b1e-307b690c1c64',
  'free',
  'Alberta Separate school. Authority: The Medicine Hat Roman Catholic Separate School Division. Code: 6877'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '55d3c1da-80d8-59c1-983f-ec19012fcb8a',
  'St. Mary''s Elementary School',
  '5ade05e1-db42-555a-b0b6-4e7a238b0590',
  'free',
  'Alberta Separate school. Authority: Lloydminster Roman Catholic Separate School Division. Code: 0595'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0ac8bee6-29bd-57d1-af2f-1db6792f1ab8',
  'Mother Teresa Early Childhood Education Centre',
  '5ade05e1-db42-555a-b0b6-4e7a238b0590',
  'free',
  'Alberta Separate school. Authority: Lloydminster Roman Catholic Separate School Division. Code: 1756'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3770d7df-a5f5-5d50-832f-7bec92b27edf',
  'LCSD Home School',
  '5ade05e1-db42-555a-b0b6-4e7a238b0590',
  'free',
  'Alberta Separate school. Authority: Lloydminster Roman Catholic Separate School Division. Code: 2341'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b75106bb-110f-5cf9-b5da-a1052e68f93d',
  'Holy Rosary High School',
  '5ade05e1-db42-555a-b0b6-4e7a238b0590',
  'free',
  'Alberta Separate school. Authority: Lloydminster Roman Catholic Separate School Division. Code: 3852'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7f7cce7c-5161-5fd9-9bb4-4f8d1284da4c',
  'St. Joseph''s Elementary School',
  '5ade05e1-db42-555a-b0b6-4e7a238b0590',
  'free',
  'Alberta Separate school. Authority: Lloydminster Roman Catholic Separate School Division. Code: 3853'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b6172154-3c7d-5234-b5eb-90edcfda6aee',
  'St. Thomas Elementary School',
  '5ade05e1-db42-555a-b0b6-4e7a238b0590',
  'free',
  'Alberta Separate school. Authority: Lloydminster Roman Catholic Separate School Division. Code: 3854'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9a624788-3d19-5091-9404-5a1fe9afbce8',
  'École Les Cyprès',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 0520'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5bc3e3df-5885-52e5-8ef1-6af76b57e615',
  'École de la Source',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 1014'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fda19a39-2c16-5b8c-9acd-6f867e4693a9',
  'École Notre-Dame des Monts',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 1060'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e258c334-c1d8-5d98-ad21-ff672e08d7cb',
  'École Notre-Dame des Vallées',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 1189'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '137388be-e15b-54ee-9f51-bf073c43a1f1',
  'École Le Ruisseau',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 1247'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '89c8ef81-decb-568f-bbb9-80c57749258c',
  'École des Hautes-Plaines',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 1269'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a360fd56-6751-5a80-86fc-9bef09738660',
  'École Beausoleil',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 1297'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a046d85a-13fd-564c-a599-7b252aec5b7f',
  'École Terre des Jeunes',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 1364'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3a7824be-6eca-50ae-a9a8-6cb5d1bd1da9',
  'École La Mosaïque',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 1365'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8934a1ea-b17d-5d35-a50c-18e6f4c3b920',
  'École Notre-Dame-de-la-Paix',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 1378'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '85c4f4b0-7164-5468-a3b8-653257defa7e',
  'École du Nouveau-Monde',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 2149'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '53773097-2049-5d62-8ce7-b19543a1ec4b',
  'École des Grands-Vents',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 2387'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8916666b-e21b-5c70-95da-143667d935f7',
  'École La Vérendrye',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 2539'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e7920e61-3ebd-59f0-a990-7862c34ecaa6',
  'École francophone de Cardston',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 2616'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '19e0e5c6-9ba5-5c21-8b8e-16a0ab9c7b38',
  'École Sainte-Marguerite-Bourgeoys',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 8707'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '79a518cd-947d-5db3-b7b3-0d880d6875f9',
  'École de la Rose sauvage',
  '75101999-84ec-58d2-81bd-48bd0e3e2a52',
  'free',
  'Alberta Francophone school. Authority: The Southern Francophone Education Region. Code: 9228'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '03af3beb-2dbf-5dce-bc74-91f5992f8042',
  'École Publique Gabrielle-Roy',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 0026'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e849d0f8-54ba-55ed-bfe4-35c9752081df',
  'École Saint-Christophe',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 0438'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ac5a6bcd-b49a-5576-86d7-27766277af0e',
  'École Desrochers',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 1050'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a5f6ba78-9cc5-5cf8-a098-5ec77bafa83e',
  'Centre francophone d''éducation à distance',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 1363'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0c3d4586-157f-5353-b4b4-c579566bc369',
  'École À la Découverte',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 1371'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2e20359e-b9cc-5c48-9339-525288b3cd85',
  'École Joseph-Moreau',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 1466'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '55e4cad9-63cf-53e0-8770-8492f42a3a94',
  'École Alexandre-Taché',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 1467'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '72197c5f-5f0e-547c-8024-d0d802f9caf7',
  'École Quatre-Saisons',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 1786'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2efc320c-74ca-5085-8587-5c905701ac09',
  'École Boréale',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 1870'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2d97d8d3-8e34-59eb-b94d-f91510c06d97',
  'École des Fondateurs',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 1907'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c97d6eee-cf32-5df5-af6f-8502241ea7ec',
  'École Sans-Frontières',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 1959'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9f45a8a7-af4d-562b-ba65-ab9b1556cb9f',
  'École Claudette-et-Denis-Tardif',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 1986'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7a2e7490-55f7-5d41-abfb-2f897c1e2d40',
  'École Michaëlle-Jean',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 2125'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd7e58427-f031-5c60-80bf-4b37e2a9d809',
  'École La Trinité',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 2434'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fb996489-e8ab-568e-9b2c-2c9d66030765',
  'École Citadelle',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 2536'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3eb8d3a7-03e4-5e2c-83b0-d1ce385745ae',
  'École La Mission',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 2537'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '27660fb1-fcc1-524c-87ac-1b1cf42f279b',
  'École La Prairie',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 2538'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b6b9a128-ec56-5913-8977-c5ba22cee671',
  'École Jean-Claude-Mahé',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 2599'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd0215c24-f87d-5252-b177-e3f9e7f1feb5',
  'École Père-Lacombe',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 8002'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '462c1e25-c46b-5ff2-88c8-088495a98d8e',
  'École Notre-Dame',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 8007'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '68a88f85-ab72-523f-83a0-98426b1e3b48',
  'École Ste-Jeanne-d''Arc',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 8025'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6d70f764-619b-5538-8154-2da68c588435',
  'École Maurice-Lavallée',
  'df7e141c-6a49-5326-931f-5c7280cb5fd5',
  'free',
  'Alberta Francophone school. Authority: The Greater North Central Francophone Education Region. Code: 8098'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3ce60aaf-2e9f-5b2e-9a73-f623d6f927fa',
  'École Nouvelle Frontière',
  'ed9a2e7b-8278-515f-a881-f208c244c877',
  'free',
  'Alberta Francophone school. Authority: The Northwest Francophone Education Region. Code: 0367'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cef25cbd-e7e9-5377-90e7-70c68abd1a46',
  'École des Quatre-Vents',
  'ed9a2e7b-8278-515f-a881-f208c244c877',
  'free',
  'Alberta Francophone school. Authority: The Northwest Francophone Education Region. Code: 0434'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd38fb369-bba0-5984-a316-4491b86d54f9',
  'École Héritage',
  'ed9a2e7b-8278-515f-a881-f208c244c877',
  'free',
  'Alberta Francophone school. Authority: The Northwest Francophone Education Region. Code: 1550'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e1a7fefb-385a-5e09-9a52-29d40d7f1eab',
  'École Sainte-Catherine',
  '6a0f7c7c-5efe-5d64-bbdf-e4195e5e75da',
  'free',
  'Alberta Francophone school. Authority: The East Central Francophone Education Region. Code: 1904'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a8889b12-4426-5649-a85e-36088aa7b174',
  'École Beauséjour',
  '6a0f7c7c-5efe-5d64-bbdf-e4195e5e75da',
  'free',
  'Alberta Francophone school. Authority: The East Central Francophone Education Region. Code: 2718'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7aa8f493-73b1-5712-aff8-dba88817306d',
  'École des Beaux-Lacs',
  '6a0f7c7c-5efe-5d64-bbdf-e4195e5e75da',
  'free',
  'Alberta Francophone school. Authority: The East Central Francophone Education Region. Code: 2876'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cb8bc867-b3ef-5efd-b33e-b4e056b0f3da',
  'École du Sommet',
  '6a0f7c7c-5efe-5d64-bbdf-e4195e5e75da',
  'free',
  'Alberta Francophone school. Authority: The East Central Francophone Education Region. Code: 2892'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a71c7871-e741-56c0-ac56-521b37ba528a',
  'École Voyageur',
  '6a0f7c7c-5efe-5d64-bbdf-e4195e5e75da',
  'free',
  'Alberta Francophone school. Authority: The East Central Francophone Education Region. Code: 2985'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '914b0881-c6cf-5c4a-ac4e-931d59fbef65',
  'FFCA High School Campus',
  'c930a895-4a88-5847-be85-55e3c05ab921',
  'free',
  'Alberta Charter school. Authority: Foundations for the Future Charter Academy Charter School Society. Code: 0012'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ae1747af-eb78-5438-95d6-4a7ea19068e6',
  'Southeast Elementary Campus',
  'c930a895-4a88-5847-be85-55e3c05ab921',
  'free',
  'Alberta Charter school. Authority: Foundations for the Future Charter Academy Charter School Society. Code: 1348'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'be6c8c54-5059-56bf-9b77-7111e51ade2d',
  'Northeast Elementary Campus',
  'c930a895-4a88-5847-be85-55e3c05ab921',
  'free',
  'Alberta Charter school. Authority: Foundations for the Future Charter Academy Charter School Society. Code: 1349'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9310773b-3cab-53ff-8643-64d00197d819',
  'Northwest Elementary Campus',
  'c930a895-4a88-5847-be85-55e3c05ab921',
  'free',
  'Alberta Charter school. Authority: Foundations for the Future Charter Academy Charter School Society. Code: 1350'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '358f11e7-fc2a-5706-9616-4cff46e25d73',
  'South Middle School Campus',
  'c930a895-4a88-5847-be85-55e3c05ab921',
  'free',
  'Alberta Charter school. Authority: Foundations for the Future Charter Academy Charter School Society. Code: 1351'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6fa030d9-7416-5111-8c48-8eb73188127a',
  'Southwest Elementary Campus',
  'c930a895-4a88-5847-be85-55e3c05ab921',
  'free',
  'Alberta Charter school. Authority: Foundations for the Future Charter Academy Charter School Society. Code: 1352'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '72e4907f-9cc9-5201-a7af-388cecd42866',
  'North Middle School Campus',
  'c930a895-4a88-5847-be85-55e3c05ab921',
  'free',
  'Alberta Charter school. Authority: Foundations for the Future Charter Academy Charter School Society. Code: 1426'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0c617013-b3be-5d20-aa3b-db9ed17ab96f',
  'FFCA South High School Campus',
  'c930a895-4a88-5847-be85-55e3c05ab921',
  'free',
  'Alberta Charter school. Authority: Foundations for the Future Charter Academy Charter School Society. Code: 2343'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '67524e3f-5a94-5e2e-878a-a3f3f225a37b',
  'Suzuki Charter School',
  '49f6cf58-bfed-52ce-aeca-06699b353b30',
  'free',
  'Alberta Charter school. Authority: Suzuki Charter School Society. Code: 6004'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e86165e8-def1-513d-928d-5bdb493f6610',
  'Connect Charter School',
  'd5e38c23-0aae-5c47-87f3-55da298dfc0b',
  'free',
  'Alberta Charter school. Authority: Connect Charter School Society. Code: 0335'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'edf1a43a-1ef3-5020-8f55-e665c93073fb',
  'Westmount Elementary School',
  '28c8a17a-cc76-517f-b0aa-6e402ac0062d',
  'free',
  'Alberta Charter school. Authority: Westmount Charter School Society. Code: 1580'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2b8c524c-252b-51ee-97ee-4bb755c1208a',
  'Westmount Mid/High School',
  '28c8a17a-cc76-517f-b0aa-6e402ac0062d',
  'free',
  'Alberta Charter school. Authority: Westmount Charter School Society. Code: 6002'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '09316691-8957-5b13-baf4-4fb0306c81d5',
  'Calgary Arts Academy',
  '87976353-51e3-5fa3-aafd-378d9bf5448c',
  'free',
  'Alberta Charter school. Authority: Calgary Arts Academy Society. Code: 1126'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '359f679f-7026-506a-8662-a5e36c24814c',
  'Calgary Girls Charter School',
  '1900c524-90b4-59e5-811f-808ea632a1a1',
  'free',
  'Alberta Charter school. Authority: Calgary Girls'' School Society. Code: 1128'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '83ef4472-4a40-5295-a7d5-72463695c87d',
  'Valhalla Community School',
  '841aaeaf-7515-5aa8-8f1c-ea2d6ff2b753',
  'free',
  'Alberta Charter school. Authority: Valhalla School Foundation. Code: 1439'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fc76f026-2459-51ec-a715-876a1d5481a6',
  'Footprints for Learning Charter Academy',
  '6cf8a729-8aaa-530e-bf39-aceaaf1907d2',
  'free',
  'Alberta Charter school. Authority: Footprints for Learning Society. Code: 2646'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c0dce4ad-7628-5b29-ba72-f6125bd36681',
  'New Humble Community School',
  'bb0d97c8-67ef-5a96-b0a3-71fbc613cb70',
  'free',
  'Alberta Charter school. Authority: New Humble Community School Association. Code: 2356'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '89074821-2a0e-5d4e-a130-0b1fdd3d1477',
  'STEM Innovation Academy Middle School',
  '18c823d3-74f2-51ef-98ef-bdd53879afb3',
  'free',
  'Alberta Charter school. Authority: STEM Innovation Academy Society. Code: 2357'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd8fd5146-e758-5254-b9e2-a0ece6766951',
  'STEM Innovation Academy High School',
  '18c823d3-74f2-51ef-98ef-bdd53879afb3',
  'free',
  'Alberta Charter school. Authority: STEM Innovation Academy Society. Code: 2449'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd30e271b-8a2f-5d97-b6c5-710836c6e72e',
  'Calgary Classical Academy',
  'cfd03923-2bbb-56a8-8f30-e7ffe8be1598',
  'free',
  'Alberta Charter school. Authority: Alberta Classical Academy Ltd.. Code: 2429'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a509b22f-06ea-5ef4-b270-888ff7d05746',
  'Alberta Classical Academy Edmonton Campus',
  'cfd03923-2bbb-56a8-8f30-e7ffe8be1598',
  'free',
  'Alberta Charter school. Authority: Alberta Classical Academy Ltd.. Code: 2478'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2b59e826-e0b9-5bc1-97f9-566c85ff1746',
  'Calgary Classical Academy Currie Campus',
  'cfd03923-2bbb-56a8-8f30-e7ffe8be1598',
  'free',
  'Alberta Charter school. Authority: Alberta Classical Academy Ltd.. Code: 2498'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c880c8c7-9054-566a-a711-06545dbd8abc',
  'Holden Rural Academy',
  'a74d618b-4fc5-5cf1-a6da-ca539f881fa4',
  'free',
  'Alberta Charter school. Authority: Holden Rural Academy Society. Code: 2441'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0b8fea0b-2793-58e0-8c0e-444776f01afd',
  'STEM Collegiate',
  'd44f0646-9a6b-5b10-988b-8512283bb71a',
  'free',
  'Alberta Charter school. Authority: STEM Collegiate Canada Society. Code: 2440'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c31deba3-09c8-51f1-9211-cf5dadc4a701',
  'Thrive Charter School',
  '5fa6e2b7-9e12-57ef-b6d0-137cf0a931cf',
  'free',
  'Alberta Charter school. Authority: Thrive Charter School Society. Code: 2474'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '40ccb2b5-59eb-52d8-af96-e3408944f116',
  'Fusion Collegiate',
  '441e76d5-2087-5b5d-80f4-dbacf887e603',
  'free',
  'Alberta Charter school. Authority: Fusion Education Association. Code: 2486'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '30bdddd1-21c0-56cc-bd48-c461ac2f15e2',
  'Gwynne Valley Rural Academy',
  'bdd3f6b1-9d51-558b-9db4-4499470aafb7',
  'free',
  'Alberta Charter school. Authority: Gwynne Valley Rural Education Association. Code: 2488'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '17e6e8f2-a7e4-5055-b4a7-731847a0510d',
  'The WISE Charter School',
  '0f638426-1485-590f-b5a5-332436ac01c7',
  'free',
  'Alberta Charter school. Authority: The WISE Charter Society. Code: 2639'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '62c61e12-d214-5258-a529-7ea4f7595634',
  'New Horizons School',
  '74383c55-679c-5994-b482-db8e499f7451',
  'free',
  'Alberta Charter school. Authority: New Horizons Charter School Society. Code: 6001'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0d845211-c9db-58ee-8654-8d532389a26d',
  'Boyle Street Education Centre',
  '1791cb72-63ac-512e-aa59-be8cc9eee995',
  'free',
  'Alberta Charter school. Authority: Boyle Street Education Centre. Code: 6003'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2ecb5e30-399e-57ab-bcb2-d48d59225a06',
  'Centre for Academic and Personal Excellence',
  '668615e1-fe07-5193-ac06-80b43fa7a916',
  'free',
  'Alberta Charter school. Authority: CAPE - Centre for Academic and Personal Excellence Institute. Code: 6005'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a0cdf223-09f1-5e8d-880f-f94ab8333c83',
  'Aurora Academic Charter Secondary School',
  '06cc9841-255a-5648-9ce9-50df8db90dd9',
  'free',
  'Alberta Charter school. Authority: Aurora School Ltd.. Code: 2439'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '07d65e50-6688-5709-b36c-c9d0dd74eb1e',
  'Aurora Academic Charter Primary School',
  '06cc9841-255a-5648-9ce9-50df8db90dd9',
  'free',
  'Alberta Charter school. Authority: Aurora School Ltd.. Code: 6006'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5c5564d4-0419-5f24-96c5-d956092b9f05',
  'Almadina Language Charter Academy, Ogden Campus',
  '5786e633-0455-5705-a127-49ade09a7bba',
  'free',
  'Alberta Charter school. Authority: Almadina School Society. Code: 1725'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8ed428de-a591-503c-84a5-790ece1850b6',
  'Calgary Charter School Hub – Almadina Campus',
  '5786e633-0455-5705-a127-49ade09a7bba',
  'free',
  'Alberta Charter school. Authority: Almadina School Society. Code: 2631'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a81d6088-fac8-59cc-99c8-3adb423cfb6e',
  'Almadina Language Charter Academy, Mountain View Campus',
  '5786e633-0455-5705-a127-49ade09a7bba',
  'free',
  'Alberta Charter school. Authority: Almadina School Society. Code: 6007'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b11798c8-9251-5520-8775-94ac4db711d4',
  'The Chinese Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Chinese Academy Foundation. Code: 0013'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f2ab6a01-1045-51d0-b886-d6f8159a65f6',
  'Webber Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Webber Academy Foundation. Code: 0021'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ee838b8b-4ef7-5541-86cd-0387d4cb8692',
  'Tween Valley Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Tween Valley Fellowship/Tween Valley Christian School. Code: 0022'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ac9c1775-0414-5e49-809c-0f44d3d59621',
  'The Third Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Third Academy International Ltd.. Code: 0031'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b952b5f7-3385-5fb6-9b24-736266b3364e',
  'Third Academy Calgary South',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Third Academy International Ltd.. Code: 1446'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1e7c7330-d68d-5799-b590-192203ecd437',
  'URSA',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Third Academy International Ltd.. Code: 2320'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd49da983-e4c0-5762-b07d-55a9ade908a9',
  'LYNX West',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Third Academy International Ltd.. Code: 2422'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9ded4874-0662-59a1-a042-13592d943e35',
  'LYNX East',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Third Academy International Ltd.. Code: 2472'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a5b5a324-3f51-5b03-a37a-032153435993',
  'Janus Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Janus Academy Society. Code: 0032'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd0c4daed-5ff4-5ca0-b154-c06339f570a2',
  'Janus Academy Junior/Senior High School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Janus Academy Society. Code: 1323'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0c7d3d07-1619-5baa-ba44-30a1c959d7a3',
  'Harvest Baptist Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Independent Baptist Christian Education Society. Code: 0098'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2b511e74-30ed-5bd5-b103-3c01f9a35e85',
  'Britannia Children''s Center',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Montessori Education Preschool & ECS Institute of Alberta. Code: 0119'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e6ffe75b-3cb4-5848-b5e3-dde60f34d89d',
  'Carousel Children''s Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Montessori Education Preschool & ECS Institute of Alberta. Code: 0374'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '66316f63-67c6-5918-8ff5-75af3ba7620c',
  'Alpine Children''s Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Montessori Education Preschool & ECS Institute of Alberta. Code: 0442'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '980c2064-544a-5ebb-82f7-d4922f413091',
  'Bonavista Children''s Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Montessori Education Preschool & ECS Institute of Alberta. Code: 0443'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '27bbb36b-7ee5-50d7-a351-0d61d8137641',
  'Ranchlands Montessori Children''s Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Montessori Education Preschool & ECS Institute of Alberta. Code: 1218'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3f294c18-3af8-5878-98e2-a148c117bb78',
  'Mountain View Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Mountain View Academy Society. Code: 0308'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1b6bd380-7af0-5e06-b21a-a5600f64a39b',
  'Personalized Learning Activities and Community Education',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Centre for Autism Services Alberta. Code: 0344'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9b3fdeae-c0ea-5cd8-a40f-2d09a53c45a7',
  'Personalized Learning and Community Education South',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Centre for Autism Services Alberta. Code: 2565'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '18390e46-8869-5576-ade8-011e68f8c8c4',
  'Banbury Crossroads Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Banbury Crossroads School. Code: 2614'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '91ae625f-c629-5c0c-b209-c2c695769c27',
  'Banbury Crossroads School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Banbury Crossroads School. Code: 9935'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e128bc43-6005-5924-98af-ceb1bc107e5f',
  'Slave Lake Christian Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Slave Lake Koinonia Christian School Society. Code: 1696'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0aa79755-b27e-57a7-a58c-8f37bd421f82',
  'Edge School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Edge School For Athletes Society. Code: 0428'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'af664809-3f4b-5cdf-9795-1c707fc6cebc',
  'New Heights School and Learning Services',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: New Heights School and Learning Services Society. Code: 0432'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7a3527aa-1558-52f9-bf95-e1173ed68bd5',
  'Eastside Christian Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Eastside City Church and Missionary Society. Code: 0478'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cedb2400-3c51-5f30-8609-1d1416c2850a',
  'Aspire Special Needs Resource Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Aspire Special Needs Resource Centre. Code: 0289'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '43261b4a-3666-59fc-ac3b-98463dab9a88',
  'Foothills Alliance ECS',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Foothills Alliance Kindergarten Society. Code: 0263'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5a848793-3225-53d6-95d5-3fbd3e8a4cda',
  'Early Discoveries Childhood Services',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Early Discoveries Childhood Services Ltd.. Code: 0992'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e2989478-a849-5e97-8b46-79c13e94fa0b',
  'Edmonton Khalsa School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Edmonton Khalsa School Educational Association. Code: 1006'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '10652b65-882d-5d3b-b97f-8723c721dddb',
  'Headway School Society of Alberta',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Headway School Society of Alberta. Code: 1008'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '643bad3c-35f2-595d-8682-007bd8c26bdf',
  'Corbett Hall Early Education Program',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Department of Communication Sciences and Disorders. Code: 1032'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2a86cfeb-b480-5c0c-bfe1-05716f1d34df',
  'Vermilion and Area Brighter Beginnings',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Vermilion and Area Brighter Beginnings Society. Code: 1037'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '97bada9e-f9d8-53a2-ac9c-492b4a10ccc6',
  'Yufeng Chinese School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Yufeng Chinese School Centre. Code: 1048'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f7b270d6-4fe7-5b94-828e-e91983c9713c',
  'Yellowhead Koinonia Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Yellowhead Koinonia Christian School Society. Code: 0323'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a449975c-ee1a-577d-ab4b-12f3abb1139e',
  'Lead Foundation',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Lead Foundation. Code: 1062'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '83aa978a-d502-524e-a6e0-f5da47510a31',
  'Clareview Head Start',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Edmonton City Centre Church Corporation. Code: 1173'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e02ffa55-66a5-57a4-934e-8ea289a093e6',
  'German Language School Society of Edmonton',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: German Language School Society of Edmonton. Code: 7925'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '185573b8-0d92-57ab-b9c1-b5e137eb9ed7',
  'SCcyber E-learning Community',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: SCcyber ELearning Institute. Code: 1246'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bc8af14d-b439-549e-808c-edf6d3ca9bb0',
  'SCcyber E-Learning Institute',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: SCcyber ELearning Institute. Code: 2372'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f1bb13b3-6e62-5d5d-8b93-4b5a7678d26b',
  'Canadian Montessori School North',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Canadian Montessori School Ltd.. Code: 1685'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd2a6d1ac-ec75-58f5-8ca1-9a3fca6e46b9',
  'Canadian Montessori School West',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Canadian Montessori School Ltd.. Code: 1686'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a04f2be3-43a4-52bc-9038-c467cda2243a',
  'Canadian Montessori School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Canadian Montessori School Ltd.. Code: 1981'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e8267686-319c-5259-a6d5-97213d666dd7',
  'Behaviour Therapy and Learning Centre Ltd.',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Behaviour Therapy and Learning Centre Ltd.. Code: 1249'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fc24b88b-80c5-58ce-9eaf-c42009ce7aba',
  'Phoenix Education Foundation',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Phoenix Education Foundation. Code: 1264'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7d537849-f11b-521c-bf93-e13d9adaec0e',
  'Okotoks Montessori Preschool',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Okotoks Montessori Preschool Society. Code: 1265'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '84d36402-e592-51f7-b5cc-c2dbf8aefc88',
  'Okotoks Montessori School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Okotoks Montessori Preschool Society. Code: 1588'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '133e8e00-5417-59bf-a85d-eb744d774323',
  'Allen Gray Child Development Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Gray House Guild. Code: 1280'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5fd5fa32-eede-5b2e-a087-fe3be8c04231',
  'I''m For Kids Team',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: I''m For Kids Team Ltd.. Code: 1316'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '04f67942-d211-525d-8f63-339e8f955db3',
  'Children''s Autism Services of Edmonton',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Children''s Autism Services of Edmonton. Code: 1343'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9434789e-9ad6-58af-90d7-9e676a628c7e',
  'Maier Centre South',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Children''s Autism Services of Edmonton. Code: 2484'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6715618b-9656-54d3-b270-90e489abeb7b',
  'Jim Jiwani Autism Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Children''s Autism Services of Edmonton. Code: 2649'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '034115f3-0790-5a75-ac9e-4d7012b15bab',
  'Khalsa School Calgary Educational Foundation',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Khalsa School Calgary Educational Foundation. Code: 1383'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e15c7eea-656e-57fb-9b6c-e7718102dded',
  'Dalhousie Community Kindergarten',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Dalhousie Community Kindergarten Society. Code: 1386'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '63c47b14-882a-5ede-b378-91e3785fb448',
  'Aurora Learning Foundation',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Aurora Learning Foundation. Code: 1387'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c59e07e9-814d-54ef-84c8-47b0b37c3fe6',
  'Aurora Learning Calgary',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Aurora Learning Foundation (Calgary). Code: 1397'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f7d51f7a-cabb-5182-93d4-fb7b4c929ada',
  'Maria Montessori School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Maria Montessori Education Centre of Calgary, Ltd.. Code: 1410'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '139a117a-1d38-5a50-90aa-713f8a3b1719',
  'Maria Montessori School - cSPACE King Edward Location',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Maria Montessori Education Centre of Calgary, Ltd.. Code: 2167'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'cd78bed1-dd00-5ffb-b6a7-c0b586bf8bb7',
  'Tanbridge Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Tanbridge Academy. Code: 1411'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '64acf893-bada-5da7-851f-5dd22319afdf',
  'Oaks & Acorns Montessori ECS/Kindergarten - Midnapore',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Montessori Projects of Alberta Ltd.. Code: 1415'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd3789543-7cdf-5b8e-8b49-8f7730ff241e',
  'Oaks & Acorns ECS/Kindergarten - Seton',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Montessori Projects of Alberta Ltd.. Code: 1535'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a4db6bd9-6741-5790-b524-422afced90cd',
  'Atlas Learning Academy Ltd.',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Atlas Learning Academy Ltd.. Code: 1435'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '869aec10-e32d-5309-9118-67c4600224ed',
  'Airdrie Foundation Four Early Childhood Intervention',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Airdrie Foundation Four Early Childhood Intervention. Code: 1437'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '29f13eba-82f9-535e-a22a-ead3ba122223',
  'Living Truth Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Living Truth Christian School Society. Code: 1474'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '13aa276d-4569-5e05-a9c3-c0a337a6afba',
  'Little Angels',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Al-Ghani Learning. Code: 1476'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'caf8f1f2-bd6b-594a-956f-7e8384999bd3',
  'Asasa Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Al-Ghani Learning. Code: 1623'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'df1a38ee-090a-5eaa-8cd7-7336928e6e43',
  'MAC Islamic School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Muslim Association of Canada. Code: 1557'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1825334d-cc6c-593a-95eb-6f3a15633cbe',
  'MAC Islamic School - Calgary Chapter',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Muslim Association of Canada. Code: 2178'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd71a296f-7548-5feb-b939-0b84a11f9834',
  'MIS Junior and Senior High Campus',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Muslim Association of Canada. Code: 2655'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5d5b69fd-93b8-59a0-a0de-6e845861736c',
  'Montessori Children''s House Academy Ltd #1',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Montessori Children''s House Charity Foundation of Calgary. Code: 1586'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '957bb091-0a2f-553c-b579-589054963979',
  'Montessori Children''s House Academy Ltd #2',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Montessori Children''s House Charity Foundation of Calgary. Code: 1595'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '41199238-e265-5c5c-b5f4-56c555a3eec0',
  'Montessori Children''s House Academy Ltd #3',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Montessori Children''s House Charity Foundation of Calgary. Code: 1596'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '89b1ad09-d5e8-5bcc-acca-b33eaea17d96',
  'Airdrie Learning Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Kin-Dir Education Foundation. Code: 1587'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4040e93b-4ae1-558d-b34f-c27bb25c083f',
  'Seden Centre for Child Development and Wellness',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Seden Centre for Child Development and Wellness. Code: 1592'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '33968441-e4b4-55c8-9b0b-ddb24348eb15',
  'Alberta Ballet School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Alberta Ballet Company. Code: 1598'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0e5684b2-9666-5ac2-b6d9-d5eaefba5856',
  'Brooks Early Learning Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Brooks Community Enrichment Foundation. Code: 1716'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f94f6aca-9f67-5fa5-a365-dd091c671397',
  'Pembina Valley Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Church of God in Christ Mennonite Pembina Valley Congregation. Code: 1744'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '16867211-44f7-52ac-83d8-651b80cd3971',
  'Renert School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Renert School Foundation. Code: 1747'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a89e7def-d92b-5131-ab1d-abd75ee7e7ad',
  'Aboriginal Head Start - St. Francis Site',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Amiskwaciy Cultural Society. Code: 0528'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7d1ed68e-f35a-5832-9804-4567f7c9c7c6',
  'Aboriginal Head Start - St. Pius Site',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Amiskwaciy Cultural Society. Code: 1254'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '908bb077-2f23-5ad6-8b6f-fde7aa8433a4',
  'Aboriginal Head Start - Our Lady of Peace',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Amiskwaciy Cultural Society. Code: 1255'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4a3f7fb2-03c7-5ec7-9e99-c6467c7fb41f',
  'CAFA Playschool Family and Early Development Program',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Canadian Arab Friendship Association of Edmonton. Code: 1861'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '622b1a5e-ebc3-53dc-a014-d60fd9131b8b',
  'Nebula Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Nebula Foundation. Code: 1911'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bcc13876-0b11-5b6d-9bc9-726c33303179',
  'Al-Mustafa Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Al Mustafa Academy & Humanitarian Society. Code: 1912'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '07530307-59f1-5820-b11e-ff47c21640f8',
  'Al Mustafa North Location',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Al Mustafa Academy & Humanitarian Society. Code: 2176'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd5586cb1-5ecd-50b0-9ad1-d91a0e9fa3ec',
  'Horizon Heritage Arabic School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Horizon Academy Institute. Code: 1913'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ae2451a5-f5d3-5058-8c8e-26d261b218c4',
  'Chiniki Community College',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Chiniki Community College. Code: 1919'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '70074b80-9743-5644-b7b9-dae4644e19c7',
  'Cochrane Valley Montessori School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: 1620215 Alberta Ltd.. Code: 1909'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6daa2c83-d000-5b94-af58-2583913b3257',
  'Cochrane Valley Montessori School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: 1620215 Alberta Ltd.. Code: 1922'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '373250ec-abca-5cfb-8745-7bc7b1f11471',
  'Step By Step Early Intervention Program',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Step By Step Early Intervention Society. Code: 1961'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9ef772d2-1a73-5069-8015-60980b303161',
  'Apple Tree Preschool',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Trail Kids Ltd.. Code: 1962'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '282e506c-878f-50e1-8a5d-daca6f25ab7e',
  'Kids at Play Preschool',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Trail Kids Ltd.. Code: 1963'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bab0c3fe-3a4e-564b-9b6d-20ef90c4e893',
  'Children''s Commons Ecological Society Nature Kindergarten',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Children''s Commons Ecological Society. Code: 1965'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd43529f1-5dc6-5b2a-baaf-70546bacafc5',
  'Calgary Nature Kindergarten - Rosemont',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Children''s Commons Ecological Society. Code: 2420'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd48e8309-83c6-582b-851c-05a62aba1b47',
  'Opokaa''sin Early Intervention Society',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Opokaa''sin Early Intervention Society. Code: 1975'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dba90e09-f3ad-5d9b-bab9-880e1221ecdf',
  'North Point School - DSEPS',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: North Point School for Boys. Code: 1982'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '89b303c4-8fc5-5c02-a2af-0275d0bc8220',
  'North Point School for Boys',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: North Point School for Boys. Code: 2318'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '595f3bb7-701b-5e72-860d-cc0208e6fbbd',
  'North Point School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: North Point School for Boys. Code: 2448'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd669e23d-49a4-5fa0-b398-2d2eb44f4cfb',
  'E2 Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: E2 Society for Twice-Exceptional Learners. Code: 1983'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '43d29722-ff2d-544b-8b85-f22f0c663a40',
  'Summit West Independent School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Independent School Authority Ltd.. Code: 1984'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e1902852-2c2a-5069-bb5f-f25fcb61c907',
  'Summit West Independent School - Elementary Division',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Independent School Authority Ltd.. Code: 2645'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ddc6b63f-1c98-52ac-9039-d73d28655d91',
  'Learning From Play',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Learning From Play Educational Foundation. Code: 2117'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '54e04859-c736-5237-9695-33efc3c324b9',
  'First Steps Elementary Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: First Steps Elementary Academy. Code: 2132'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7f7c67f5-7a44-5cfa-a1e1-3413ca69ffe5',
  'AlBaqir Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: AlBaqir Academy Association. Code: 2173'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bf06004e-a3bf-5a2f-9b4a-1f4adf6ea47d',
  'Gobind Sarvar School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Gobind Marg Charitable Trust Foundation. Code: 2174'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6cd194ff-2d2b-55e4-ac1c-04c0cb80278d',
  'Gobind Sarvar School Guru Nanak Gate Campus',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Gobind Marg Charitable Trust Foundation. Code: 2479'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c712735d-2ba9-5dc6-801c-42eb72bc1ebf',
  'Kids Developmental Services Ltd.',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Kids Developmental Services Ltd.. Code: 2236'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '604eb55c-c91a-5144-8b06-0fdb8c1f7320',
  'CASA Preschool Day Program',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: CASA Child, Adolescent and Family Mental Health. Code: 2244'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b64cc1fe-c83d-5a91-82f3-5bc73f5cf7fb',
  'Wildflowers Childcare',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Municipality of Jasper. Code: 2254'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a402b54b-b947-5620-98c7-ce344f0e54d7',
  'Montessori Alberta',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: 2128607 Alberta Ltd.. Code: 2255'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '811002f6-b57b-54a7-a3f8-7e3bfede521c',
  'Hillcrest Montessori Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Fort McMurray Montessori Foundation. Code: 2261'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '25dacf02-d305-535e-bfb1-d6cda2e81989',
  'Hellenic Academia Institute',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Hellenic Academia Institute. Code: 2284'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '02335413-42b1-560b-9025-24d8ddee4965',
  'Calgary International Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Calgary International Academy Ltd. Code: 2319'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd68f12e9-4e41-5164-b02f-7e6bf9742eca',
  'Calgary International Academy ECS',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Calgary International Academy Ltd. Code: 2323'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5bb71887-d06e-5415-bb1f-fc58f6246b51',
  'Maximize Early Childhood Services',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Maximize Services for Special Needs Society of Alberta. Code: 2321'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1320ef7e-9727-59da-830b-28afa18026d8',
  'Brighter Futures',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Edson Friendship Centre. Code: 2322'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9f404ece-b845-5b64-820e-4d4b7012494e',
  'Great Journeys Learning Centre Kindergarten',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Great Journeys Learning Centre Society. Code: 2325'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '07e72586-72d4-5177-a403-7dabcc5ada36',
  'Learning Potential',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Learning Potential Foundation. Code: 2329'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '626f537f-198a-577a-93c9-27e7045b90fa',
  'Learning Potential Kindergarten',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Learning Potential Foundation. Code: 2615'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '942ef21d-c727-563b-ad2a-15f8d9308dfc',
  'Spanish Montessori School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Spanish Montessori Society. Code: 2332'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1cce2855-8302-57e2-bc28-24c0ac8b5d5a',
  'The Gilbertine Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Gilbertine Institute of Catholic Studies. Code: 2338'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b8b3ab16-891f-5343-9d02-cc7f49392af7',
  'Villa Spiritus',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Gilbertine Institute of Catholic Studies. Code: 2469'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0d0ccb21-62ff-507f-bd53-19db706d604f',
  'Holy House of Our Lady and St. Benedict',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Gilbertine Institute of Catholic Studies. Code: 2470'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '30ee2664-4205-5a3e-95b2-e28887ed4d2f',
  'Ahmadiyya Muslim School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Ahmadiyya Muslim Schools Society Alberta. Code: 2339'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b12ece85-bb1b-561a-9512-7b1e5247a825',
  'Wing Kei Montessori School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Wing Kei Day Care Centre. Code: 2359'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fe3c13ae-8560-5310-84ef-139420dfdbc2',
  'Creekside Creative Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Creekside Creative Academy. Code: 2366'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c9fb71c2-f3f9-5199-81aa-055d454889e5',
  'Meadows Christian Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Meadows Christian Education Society. Code: 2367'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fba24f4b-0c9b-55f9-81d8-175103a88dcc',
  'Little Scholars Kindergarten',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Little Scholars ECS Ltd.. Code: 2375'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '10792ce5-5d2d-53b8-bc1d-8ce551e24632',
  'Voyage Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Kidsbridge Association. Code: 2376'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'aff3bfeb-e672-5d5d-984c-d86f2faa9c08',
  'Legacies Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Legacies Academy Foundation. Code: 2378'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c328300f-4bd8-5421-9ed2-c8138f6c8e4a',
  'Ignite Centre for eLearning',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Ignite Alberta Institute for Learning. Code: 2379'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1853f1b4-8268-536d-9ec5-54d7bdd16e08',
  'Capstone Engineering Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Capstone Engineering Academy. Code: 2380'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7867d1df-752b-5eac-a3dd-5c9e26c4c802',
  'Education Unlimited Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Education Unlimited Network. Code: 2443'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd823d4c2-ffda-576c-9910-886ff729433c',
  'RTD Math Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: RTD Math Academy Ltd. Code: 2444'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '638440de-2f6a-5778-8855-c9105d30ec6f',
  'E.C.I. Learning Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Rockyview & District Primary Education Society. Code: 2445'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4575bc8b-1ebf-5a83-b40c-c1280a0bfb68',
  'Smart Little People Early Childhood Services',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Smart Little People Early Childhood Services Society. Code: 2456'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b7741a76-2273-5bae-beb1-dbc74f72bdde',
  'Al-Qaim International School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Al-Zahra Islamic Research Foundation. Code: 2458'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0b1bb5d2-9207-5f72-a626-96318838f1a5',
  'Gobind Sarvar School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Gobind Marg Charitable Trust Association. Code: 2468'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '46c8c2cb-9b26-5b7b-a610-bd1e3f5a52e4',
  'Alberta Heritage Language School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Alberta Chinese Cultural Education Society. Code: 2494'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1c2e1d74-eb61-5e86-a822-7db26c43e027',
  'Neriah Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Neriah Christian School Society of the Netherlands Reformed Congregation. Code: 2497'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2e968aa0-9d87-5588-8935-c5db09486051',
  'A Heart for Children',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: A Heart for Children Foundation Ltd.. Code: 2517'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7252e5e0-0e06-5729-b85c-4c007f68a40e',
  'Fueling Brains Academy Braeside',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: FBA Education Services LTD. Code: 2519'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a6c94b47-76b8-5053-b240-3549eb7a921a',
  'Fueling Brains Academy Centennial',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: FBA Education Services LTD. Code: 2520'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2434feb5-74ab-5070-b09d-516fe78bac73',
  'Fueling Brains Academy McKnight',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: FBA Education Services LTD. Code: 2521'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e1ad6775-1d17-519b-8415-7cfa04fcd32e',
  'Fueling Brains Academy New Brighton',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: FBA Education Services LTD. Code: 2522'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8b16606a-18ac-55f7-98cc-da880d99da62',
  'Fueling Brains Academy Strathmore',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: FBA Education Services LTD. Code: 2523'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '27c3c4ea-f5e1-5a50-842c-e5b34095317e',
  'Fueling Brains Academy Walden',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: FBA Education Services LTD. Code: 2524'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c9bfd808-dcc2-5b75-8094-abd3f727ac46',
  'Fueling Brains Academy West 85th',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: FBA Education Services LTD. Code: 2526'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f38f47de-b39a-51eb-a952-294c62be59d9',
  'Lady Fatima Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Lady Fatima Academy. Code: 2528'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5611386c-043c-54c9-87da-87d2634fd442',
  '1st Class Collaborative Intervention Support Services Institute',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: 1st Class Collaborative Intervention Support Services Institute. Code: 2530'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '1c1958ed-2ca1-5765-af34-9bb3fe50d4d7',
  'Arise Christian Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Arise Calgary Church. Code: 2533'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd7df94ea-e334-54fa-ad4b-7139eb6eaf16',
  'Seeds to Sprouts Early Intervention Foundation',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Seeds to Sprouts Early Intervention Foundation. Code: 2613'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '15499bc7-62a7-5b92-8ee7-82ebcff6d229',
  'Al Faruq Islamic School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Downtown Islamic Association. Code: 2644'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3c61a500-8efa-5b8e-8097-fd8fb7008909',
  'Access Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Access Academy Inc.. Code: 2648'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f966be25-3e72-5adf-a5d8-fed9fe64cf5e',
  'Fusion Christian Academy of Edmonton',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Fusion Christian Academy of Edmonton. Code: 2651'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2e058c01-6b7d-5c10-bc74-e7926bc3f8ea',
  'Aflah Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Aflah Academy Association. Code: 2654'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7416ece6-4de4-5c77-94b8-a55e32043dac',
  'St. Matthew Lutheran Christian Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: St. Matthew Evangelical Lutheran Church of Stony Plain, Alberta. Code: 2290'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8ae63336-54b9-5888-8ba9-4cbbc5626fbf',
  'Lacombe Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Lacombe Christian School Society. Code: 4392'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0c612933-b2f0-5b07-b058-1c444b17b5ae',
  'Parkland School Special Education',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Parkland Community Living and Supports Society. Code: 4493'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'db389c9c-b0c5-53f8-8dd4-a53964ce4d86',
  'Coaldale Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Coaldale Canadian Reformed School Society. Code: 6494'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4327bf0b-0f14-5d97-831b-3c96c8990547',
  'Ivan Franko Ukrainian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Society of Ukrainian Studies of Alberta. Code: 7914'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3cb910e2-add7-5df0-969e-f2efddf25e66',
  'Tempo School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Tempo School. Code: 7951'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9f0df1bb-29cb-5821-b7f7-6838d063a1da',
  'Red Deer Polytechnic Early Childhood Services',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Red Deer Polytechnic. Code: 4490'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9cba726a-55f7-5320-a22f-822cec785482',
  'River Valley School ECS',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: River Valley School Society. Code: 1906'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '67390b66-ff43-561f-bfe5-83c23c780559',
  'River Valley School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: River Valley School Society. Code: 9921'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '875f8205-5be0-5dc6-9fb1-ed8b68aaaea4',
  'Strathcona-Tweedsmuir Online',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Strathcona-Tweedsmuir School. Code: 2371'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c4299df0-11d5-587a-b725-ff7e93406c04',
  'Strathcona-Tweedsmuir School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Strathcona-Tweedsmuir School. Code: 9922'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8a7170cb-37f2-520d-b74e-07a0cdae8467',
  'Italian School of Calgary',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Centro Linguistico E Culturale Italiano Calgary. Code: 9926'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '38f736f2-0434-5c48-b521-80e63a198679',
  'Covenant Canadian Reformed School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Canadian Reformed School Society of Neerlandia. Code: 2390'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a3f14896-4e5b-5e2e-acbf-e7b7b1233dc8',
  'Parkland Immanuel Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Canadian Reformed School Society of Edmonton. Code: 2293'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7b727002-e595-5395-9c09-b58a0d44a991',
  'BCS@Home',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Bearspaw Christian School Society. Code: 2286'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '990f2e9d-16fb-58a8-8da1-fa72a8df63aa',
  'Bearspaw Christian School & College',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Bearspaw Christian School Society. Code: 9927'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9fc1fc3a-a056-5b3e-9217-f8ab6df6b70c',
  'Foothills Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Foothills Academy Society. Code: 9917'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e4e4ff54-2447-5e56-a2e6-6ef39ca8f69b',
  'Calvin Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Calvin Christian School Society of the Netherlands Reformed Congregations. Code: 6496'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '00bc2155-1f12-5444-aa39-a1a58937cdeb',
  'Glenmore Christian Academy Junior High',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: GCA Educational Society. Code: 1956'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '175d0ac8-c0bb-5e39-aa78-1f7f9934d55d',
  'Glenmore Christian Academy Elementary',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: GCA Educational Society. Code: 9928'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '43e9c1d0-a0ae-5417-b591-36bd6e025aca',
  'Destiny Christian School Society',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Destiny Christian School Society. Code: 4494'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0f5089e3-c0c1-522e-bfaf-28467656d0ef',
  'Calgary Academy Collegiate',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Calgary Academy Society. Code: 1015'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '63db3cf9-8389-556e-a313-73f655e3adcd',
  'Calgary Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Calgary Academy Society. Code: 9908'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '41db5d72-47c9-5d47-a014-4a25e6dfe051',
  'Dante Alighieri Italian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Dante Alighieri Society. Code: 7918'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7fdfe491-0c98-5bce-9c45-49870f08e74d',
  'West Island College',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: West Island College Society of Alberta. Code: 9913'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4bfb4f08-f68a-5547-a0f9-3d6aa331450a',
  'Akiva Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Congregation House of Jacob-Mikveh Israel. Code: 9914'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0adbb574-7b97-5c85-86c0-6c00ad9e3332',
  'Countryside Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Countryside Christian School. Code: 4593'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '89dd6b13-7435-5954-8e17-5be47df62d18',
  'Lakeview Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Lakeview Christian School. Code: 4691'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6fdc5ebc-b819-5e73-8f2a-b6922e09c1aa',
  'Kneehill Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Kneehill Christian School. Code: 5792'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bc7ccae6-ff70-5871-8d57-f90e72004e7d',
  'Northern Lights School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Northern Lights School Education Foundation. Code: 1392'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0830c26f-4649-585f-b72d-d1482854b64d',
  'Hilltop Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Church of God in Christ Mennonite. Code: 3893'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4282c3f6-d901-5221-b2cb-18e975879bd5',
  'Ponoka Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Ponoka Christian School Society. Code: 4294'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e70a877a-738c-5755-b693-4df0c6305c66',
  'Hillcrest Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Hillcrest Christian School Society. Code: 1194'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0a7d2c58-2f69-5c0a-be05-dd8f523fbf9d',
  'Edmonton Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Edmonton Academy Society for Learning Disabled. Code: 7953'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0d9f3d2f-4915-59d3-8f9b-a11d32c7f97a',
  'Lycée international de Calgary',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Lycee Louis Pasteur Society. Code: 9919'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'dbd49296-d7bc-50cf-895b-8914f1c39146',
  'Rockyview Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Rocky View Mennonite Church. Code: 6192'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e04e8d98-277f-5781-b6ed-a259b9d155c2',
  'Sawenegezhik Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Saddle Lake Indian Full Gospel School Mission. Code: 2794'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '810156ae-0e39-5f94-9876-2d9429d88754',
  'Koinonia @ Home',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Koinonia Christian School - Red Deer Society. Code: 2446'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7768a0b7-ff61-5925-8308-1c5b5376acb3',
  'Emmaus Learning Community - DSEPS',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Koinonia Christian School - Red Deer Society. Code: 2447'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '70d61086-0dbb-5a12-a584-a270576ce43b',
  'Koinonia Christian School (Red Deer)',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Koinonia Christian School - Red Deer Society. Code: 5195'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '69929f7a-b3f8-5c80-9b72-166d956953a8',
  'Old Sun Community College',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Old Sun Society. Code: 5591'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c0b74243-ba8f-5b2b-aff1-4eb70f04dfec',
  'Calgary Waldorf School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Calgary Waldorf School Society. Code: 9949'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '29a9ab3f-f5bd-5387-85b1-e1611f27aa38',
  'Progressive Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Progressive Academy Education Society. Code: 7938'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd9897891-249b-5165-8cc3-ee9bdacdc8ac',
  'Rundle Studio',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Rundle College Society. Code: 5002'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bdf0959d-4a08-5c30-a9f9-e0d3dcaf59cc',
  'Rundle College Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Rundle College Society. Code: 5297'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e692e58b-9eeb-5d12-88fe-839c9e543b2d',
  'Rundle College Junior Senior High',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Rundle College Society. Code: 9952'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3b24184a-aa5e-57f9-aab0-e61937cb6053',
  'Rundle College Elementary School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Rundle College Society. Code: 9979'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0cfa8f55-e04e-5efa-b6d2-97e2bc47e7be',
  'Newell Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Newell Christian School Society. Code: 6796'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '06075056-8398-513b-aee7-deab21ea1a2e',
  'The Father’s House Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Father''s House Christian Fellowship-Sturgeon County. Code: 2593'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '31a64df0-72b7-5de1-9d99-12acfc6dc8a4',
  'Rimbey Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Rimbey Christian School Society. Code: 4298'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '19af02c7-65ff-5492-baa3-f8d3c4881719',
  'Cornerstone Christian Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Cornerstone Christian Academy of Camrose. Code: 4595'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ae42be7c-b846-531c-b21b-c5ce4fd68bea',
  'Red Crow Community College',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Red Crow Community College. Code: 6296'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '027734c5-18b6-5ff8-a41c-2dcb4961cf9b',
  'Elves Adult & Youth Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Elves Special Needs Society. Code: 0655'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4b2f1769-01ef-5150-9827-2fb6a14cb7f0',
  'Elves Child Development Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Elves Special Needs Society. Code: 2166'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '42585a1d-352b-5aee-807c-78654b301a5d',
  'Edmonton Islamic Academy - Early Childhood Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Edmonton Islamic School Society. Code: 2629'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'eab60300-9c4e-5698-8bfe-5748d9bc7c1a',
  'Edmonton Islamic Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Edmonton Islamic School Society. Code: 7901'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2ca57750-6ff5-53cd-af36-98503fa296dd',
  'Airdrie Christian Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Airdrie Christian Academy Society. Code: 5197'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '89ea67da-c839-5035-94eb-6d4f65ca5717',
  'Phoenix Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Unlimited Potential Community Services Society. Code: 0028'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd1189dd8-8832-5c5d-b76e-386a22264810',
  'Thomas More Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Unlimited Potential Community Services Society. Code: 0483'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '72158b5f-d4b7-5f8a-87e6-a76f10162846',
  'Columbus Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Unlimited Potential Community Services Society. Code: 0577'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '594c7cc3-2941-5080-a541-c41774da33e4',
  'Bright Bank Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Unlimited Potential Community Services Society. Code: 2424'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '510e5d8b-f7cc-5089-a736-04e4423cc3f7',
  'Greek Community School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Hellenic Society of Calgary and District. Code: 9957'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '13062ef6-5faa-5178-b6ce-21c45f4658db',
  'Central Alberta Christian High School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Central Alberta Christian High School Society. Code: 4466'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5f3fdbf0-35fa-5e09-bbcf-9c7022b3180c',
  'Calgary Chinese Private School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Calgary Chinese Public School Society. Code: 9963'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3fb1365a-f6b7-5980-ac8f-4106464ec9f4',
  'Columbia College',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Columbia College Calgary. Code: 9964'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f8361302-f8d6-5584-924e-c86aabbb2a02',
  'Cherry Coulee Christian Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: 40-Mile Christian Education Society. Code: 6990'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0639fa17-5734-5a05-9ea1-fafb243b944a',
  'Maskwachees Cultural School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Maskwachees Cultural College Foundation. Code: 4289'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b5f5deec-4e1b-5a1a-875b-0242852d5d10',
  'Peace Christian Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Lakeland Christian School Society. Code: 2421'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '48793fa6-b833-56ef-b0f9-62a195ca8cba',
  'Lakeland Christian Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Lakeland Christian School Society. Code: 2986'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e99d2593-b5c0-5b40-a285-a91b165f5d7d',
  'Lighthouse Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Lighthouse Christian School Society. Code: 4394'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9a59863d-72be-5b42-803a-5c522c361fb5',
  'Devon Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Devon Christian School Society. Code: 3290'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '14ac3e5c-0734-5ccb-b9b6-9eba29eb6c98',
  'Gil Vicente School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Gil Vicente Edmonton Portuguese School Society. Code: 7957'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '16674ba2-0a2a-5e1c-afc2-38fd6519d25f',
  'Olds Mountain View Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Olds Mountain View Christian School Association. Code: 5198'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7a991215-eca1-52ca-9897-30b67e855a4b',
  'Living Waters Christian Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Living Waters Christian Academy. Code: 2299'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '92b6d9bb-a5a4-5d77-9f8c-35e6442d6f71',
  'Inner City High School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Inner City Youth Development Association. Code: 1163'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e14245c1-74dc-5620-9f4e-cebea49277ce',
  'Edison School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Edison School Society. Code: 5393'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '55d8c224-922d-5c2f-b65a-2221db8dce6b',
  'Delta West Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Delta West Academy Society. Code: 9972'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '042e9bb2-7d9c-5fca-86ff-1ade212e7f6f',
  'Cleardale Mennonite School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Cleardale Mennonite School Society. Code: 1197'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '26a7da12-5857-594d-b1f5-d1e3980c329a',
  'Worsely Mennonite School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Cleardale Mennonite School Society. Code: 2177'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '86583fe6-cfca-556d-bc56-8be259184307',
  'The Heartland Agency',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Heartland Agency. Code: 0285'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6916564a-5d5c-5deb-89d2-8361ecb95d00',
  'Getting Ready For Inclusion To',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: G.R.I.T. (Getting Ready for Inclusion Today) Calgary Society. Code: 0284'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e039c756-bae8-5bd2-a47f-ecf36bc2e136',
  'Clear Water Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Clear Water Academy Foundation. Code: 7976'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bc764ef0-5dcb-50c3-9c75-b39376a3498b',
  'Prairie Adventist Christian eSchool',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Alberta Conference of 7th Day Adventist Church. Code: 1633'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4a08cdc7-9a7a-5ad0-aef2-23a185e1c1cd',
  'Peace Hills Adventist School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Alberta Conference of 7th Day Adventist Church. Code: 3192'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3cf601f4-2ba1-5345-be4c-3ea10c9d70aa',
  'Mamawi Atosketan Native School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Alberta Conference of 7th Day Adventist Church. Code: 3193'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b60761bc-0cac-5250-99ff-bce5ce3e7a53',
  'Woodlands Adventist School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Alberta Conference of 7th Day Adventist Church. Code: 4293'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '924bad28-4def-5c8c-af63-dd499ca461e7',
  'College Heights Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Alberta Conference of 7th Day Adventist Church. Code: 4390'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c877e892-8755-51ac-b3ab-e50815993ddd',
  'Sylvan Meadow Adventist School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Alberta Conference of 7th Day Adventist Church. Code: 4497'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'eec74964-9ccf-5c09-b68d-cbcfdd0201fc',
  'South Side Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Alberta Conference of 7th Day Adventist Church. Code: 4498'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2b49c073-cc9b-568b-b668-6fec3de8241a',
  'Higher Ground Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Alberta Conference of 7th Day Adventist Church. Code: 5007'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0ca74bd6-1563-5d9e-9306-92bf694b0d75',
  'Coralwood Adventist Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Alberta Conference of 7th Day Adventist Church. Code: 7936'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ca83bfb7-1c78-5765-8b82-e70435db0a53',
  'Chinook Winds Adventist Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Alberta Conference of 7th Day Adventist Church. Code: 9916'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '585a6ce5-c321-5498-b2df-2cf05b6e7a57',
  'Alder Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Alder Academy Early Learning Society. Code: 0297'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5c9867db-c9e7-50a1-8aa3-a08dffff8881',
  'Solomon College',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Solomon College. Code: 7986'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ed128aed-d8d7-565c-a1dd-0606281d147f',
  'Innisfree School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Innisfree and District Early Childhood Services Association. Code: 0298'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b00fd54b-623d-570d-81d7-44ec44e26737',
  'Community Association for Lasting Success',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Community Association for Lasting Success. Code: 0299'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd4f8d0ff-fb71-57d3-959d-228e546cc02d',
  'Pacekids Programs South',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Pacekids Society for Kids with Special Needs. Code: 0302'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b228815d-55e1-5ca7-a77e-3f8e1bec877c',
  'Pacekids Programs North',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Pacekids Society for Kids with Special Needs. Code: 1949'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '20fcf8c4-1ab8-5eca-8ed9-7bb5cb311dc3',
  'High Level Christian Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: High Level Christian Education Society. Code: 1495'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '46d30e3e-c12e-57bd-99ce-24de619dfbd7',
  'Connect Society''s Early Childhood Services',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Connect Society-Deafness, Education, Advocacy & Family Services. Code: 0658'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ec574c75-ca25-5d6e-8e9f-cd20bc267560',
  'Dewberry School ECS',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Dewberry Early Childhood Parents Society. Code: 0665'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a9786927-ed34-5b8d-a198-89250fce1cae',
  'Kitscoty & District Early Childhood Education Kindergarten',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Kitscoty and District Early Childhood Education Kindergarten. Code: 0677'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '24095cc6-1b12-580b-aa56-350727424598',
  'Londonderry Child Development Society',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Londonderry Child Development Society. Code: 0681'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b6da4eb6-32d1-51dd-885c-1cc2c8c23e55',
  'Southview Child Care',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The First Mennonite Church. Code: 0684'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '46ff773c-53f5-5f35-9629-569400f709cd',
  'Norwood Child & Family Resource Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Norwood Child & Family Resource Centre. Code: 0688'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'af849b84-64e6-58eb-afc5-ac3a090819f7',
  'Sherwood Park Kindergarten',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Sherwood Park Kindergarten. Code: 0700'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b1e8db10-d355-57d6-99e2-a25f4d2ee0c3',
  'Hay Lakes School ECS',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Hay Lakes ECS. Code: 0747'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '92cf9bb8-c04a-5347-b808-e935862ea445',
  'Sedgewick ECS Portable',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Sedgewick Early Childhood Centre. Code: 0765'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '96dd99a1-2bb1-5d64-ac19-25550f81c649',
  'K-C Community Services',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: kcs Association for Early Learning, Special Needs, and Family Supports. Code: 0770'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '03f2c395-e63d-5d01-8cd1-ce9d233f6b9e',
  'Calgary French & International School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Calgary French & International School Society. Code: 0796'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '83d0b419-0eee-5ca7-9556-e1f74b3984f0',
  'Calgary Jewish Academy',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Calgary Jewish Academy. Code: 9911'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e790ff9a-4091-5f8c-af45-159127cc6c2b',
  'Renfrew Educational Services-Janice McTighe Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Renfrew Educational Services Society. Code: 0249'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9cdf01b2-30ad-5960-aaec-bda7f520ee09',
  'Renfrew Thomas W. Buchanan Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Renfrew Educational Services Society. Code: 0250'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '99d2674c-d8b0-59b5-b9f5-1013ba195735',
  'Renfrew Educational Services - Child Development Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Renfrew Educational Services Society. Code: 0280'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ade439ca-9d40-5e72-b13f-045477dd9878',
  'Renfrew Educational Services-Bowness Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Renfrew Educational Services Society. Code: 0437'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8b2298c7-553f-54f0-9832-a991a1c2d4e1',
  'Glamorgan Community Kindergarten Society',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Glamorgan Community Kindergarten Society. Code: 0850'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b7b9816e-779c-5a63-aa1f-fcafcff7e01f',
  'Lomond School ECS',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Lomond Little Learners Society. Code: 0889'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bca7d531-b7e9-5aa4-9e38-0294d242a498',
  'The Little Schoolhouse',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Bragg Creek Education Services Association. Code: 0793'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '47633cb0-ad23-59bc-a6d7-b92def915694',
  'Children''s House Day Care',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Children''s House Child Care Society. Code: 0777'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a1513db2-9d6c-562d-8c31-5ac355f854e6',
  'Thornhill Community Building Early Childhood Society',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Thornhill Child Care Society. Code: 0941'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c79d04b1-cb4a-538b-aba4-70db78abf07e',
  'Thornhill Child Care Society - Haysboro ECS',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Thornhill Child Care Society. Code: 2619'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '83e0f01a-c6b5-5bde-9332-a6f6adfe5e6a',
  'Jenner School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Cactus Country E.C.S. Association. Code: 0955'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'eac2347e-7e88-56a1-8434-0a0811b6e35a',
  'Warren Peer School ECS',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Acadia Valley Early Childhood Services. Code: 0975'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f921b2d5-3a14-5059-998e-943bafa3424c',
  'Calgary Quest School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Calgary Quest Children''s Society. Code: 5398'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'aa2ea32b-f278-5a92-9a20-36a87f3acfd2',
  'Youngstown School Early Childhood Services',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Youngstown Kindergarten Assoc.. Code: 0124'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '2ca7e061-93dc-5cf7-99d9-efd5a50def4a',
  'Providence Children''s Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Providence Child Development Society. Code: 0135'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9d09eb71-f74e-5d1f-af43-22223e0aec71',
  'Providence Children''s Centre - Falconridge',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Providence Child Development Society. Code: 1216'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f932666b-468f-52ac-ad87-13077f3a8b0d',
  'Providence Children''s Centre - Beddington',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Providence Child Development Society. Code: 1251'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'd0c72a22-10d6-5c2b-aea4-355e5de38af3',
  'Providence Children''s Centre - Midnapore',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Providence Child Development Society. Code: 1385'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5865bf7b-f8ed-53ce-b27c-f4dc8d1bb7b5',
  'Providence Children''s Centre - Hawkwood',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Providence Child Development Society. Code: 1432'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '35faa97e-7c31-5103-90f3-bc39a591feb6',
  'Providence Children''s Centre - McKenzie Towne',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Providence Child Development Society. Code: 1591'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f10b30bc-9537-56eb-9e75-758267b84f83',
  'Student''s Union & Community Day Care Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Students'' Union of the University of Alberta and Community Day Care Centre Society. Code: 0140'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7fc931f4-499b-5f4b-88b8-1e583ebfe7b2',
  'Community Preschool Education',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Community Options-A Society for Children and Families. Code: 0151'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f707da91-d7d8-58fd-994d-8aeb1b20fee9',
  'New Brigden School Portable ECS',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: New Brigden Early Childhood Services Association. Code: 0167'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3af8e36a-2b0f-5877-94c0-0b8e7bb221f9',
  'Milo ECS School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Milo Alphabets Kindergarten Society. Code: 0170'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '354a5243-23dd-504c-8c0d-f7c303783d1d',
  'Jasper Place Child Care/ECS Program',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Jasper Place Child and Family Resource Society. Code: 0173'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '9e1d121e-0e26-527a-986a-54207503206b',
  'It Takes a Village Kindergarten',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: It Takes A Village Educational Society. Code: 0179'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e4d612a0-9500-5002-9922-8c3c9fb27223',
  'Society for Treatment of Autism',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Society for Autism Support and Services (Calgary Region). Code: 0212'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5b1a9f8c-d124-59cf-8d0e-d64923b47072',
  'Arrowwood School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Arrowwood and District E.C.S. Society. Code: 0218'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '4f15fb06-ea09-58ff-b858-7690f09ba4a4',
  'Grit Program',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Getting Ready for Inclusion Today (The GRIT Program) Society of Edmonton. Code: 0136'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'fd66debf-ee2d-5deb-b857-71ade6062707',
  'The PREP Society',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The PREP Society. Code: 0230'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b5ce1b97-160e-529c-9d43-341104d20532',
  'Champion School ECS',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Champion Kindergarten Association. Code: 0234'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'b7be0716-9905-58b7-bc69-40d9f538ad37',
  'Lethbridge Montessori Kindergarten',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Lethbridge Montessori Society. Code: 0243'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '83afa3a3-4eb4-5f19-ae1f-b6d1bf88b4e2',
  'Lethbridge Montessori Kindergarten-Forestry Avenue Campus',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Lethbridge Montessori Society. Code: 1528'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '5ed2c00a-d0e0-53bb-ba15-f91c904ef86a',
  'North Campus ABC Program',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: ABC Head Start Society. Code: 1940'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8448c76e-c930-51ea-8e76-61065dbfec1c',
  'Mill Woods Town Centre campus',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: ABC Head Start Society. Code: 1943'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f0faa96a-84cb-5810-b0a5-05fab9214111',
  'ABC Head Start Society  - Milbourne Mall',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: ABC Head Start Society. Code: 1948'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '86287b05-8bc6-5ba2-8c73-0ac6ac55c5c3',
  'Westmount Campus',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: ABC Head Start Society. Code: 2330'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'c9809592-2c4c-5aa5-8c71-0d82d985c675',
  'University Day Care Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: University Child Care Centre Society. Code: 0251'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '6dec6f17-f41b-57ef-8893-cf0942a39bd9',
  'Foothills Creative Beginnings',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Foothills Creative Beginnings Preschool and E.C.S. Association. Code: 0209'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'e9f26639-51e6-5bd6-ac4e-e00949f82afb',
  'Foothills Creative Beginnings Preschool and E.C.S. Association',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Foothills Creative Beginnings Preschool and E.C.S. Association. Code: 2466'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'df2e92ef-7e1c-544d-804a-426b5ff863c3',
  'Montessori School of Calgary',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Montessori School of Calgary. Code: 0254'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'a73728f1-5cf8-5e7a-91dc-af56be774653',
  'Marlborough Day Nursery Ltd.',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Marlborough Day Nursery ECS Limited. Code: 0264'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ec56e145-cef3-5bbb-aa9d-40c059bcf73e',
  'Tiny Treasures Ellenwood',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Marlborough Day Nursery ECS Limited. Code: 0521'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '0b91ef79-310b-5035-a57d-5fecec1d88af',
  'Chestermere Learning Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Marlborough Day Nursery ECS Limited. Code: 1700'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '49caef73-8b3b-57a8-a91a-dfe16035291d',
  'McKenzie Learning Centre',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Marlborough Day Nursery ECS Limited. Code: 1739'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '09c64da8-193f-513c-9b36-035b0f6590ea',
  'Creekside Campus ECS',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Marlborough Day Nursery ECS Limited. Code: 2094'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ea534c24-809d-5b3d-9f47-5f4b2f8138db',
  'Marlborough Day Nursery ECS Ltd. West Henday Campus',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Marlborough Day Nursery ECS Limited. Code: 2262'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'bbea819b-4bfc-5ab5-b9dd-bff4a850b3cf',
  'Tyndale Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: The Canadian Reformed School Society of Calgary. Code: 9984'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'eb33f37c-bc21-5071-97d1-a838d7f5fb05',
  'Providence Christian School',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Providence Christian School Society. Code: 9986'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '733b8ea9-164e-5348-a5c6-b884308ad670',
  'Agape Early Childhood Services',
  'e3c98297-973b-5c9f-9096-6386eabd7c8f',
  'free',
  'Alberta Private school. Authority: Victory Christian Fellowship of Lethbridge (1983) Inc.. Code: 0270'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '94ee62ba-d375-5abf-96b5-6d05905d5654',
  'Kayas Cultural College',
  '77433095-757a-536e-aa53-80c31a603282',
  'free',
  'Alberta Provincial school. Authority: Kayas Cultural College. Code: 0441'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '03e0415a-6c7a-5f9c-b63d-fd3e5294df39',
  'NorQuest College (Wetaskiwin)',
  '1f71e506-50e9-5c48-9bb3-6bbf5fac7246',
  'free',
  'Alberta Provincial school. Authority: NorQuest College. Code: 3194'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '78b244cf-e0ba-5852-a07f-183e67e2e822',
  'Norquest College Tricentre',
  '1f71e506-50e9-5c48-9bb3-6bbf5fac7246',
  'free',
  'Alberta Provincial school. Authority: NorQuest College. Code: 7946'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '3ff780b1-8d16-54b6-b7a8-1c5d0fb9dc32',
  'NorQuest College Edmonton',
  '1f71e506-50e9-5c48-9bb3-6bbf5fac7246',
  'free',
  'Alberta Provincial school. Authority: NorQuest College. Code: 7995'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '7f8ff777-d8e6-56bc-b6a8-49c27e3677bd',
  'Bow Valley College - Main Campus',
  '5cf05f93-9ab6-59e4-9225-71bd8bfc4bf7',
  'free',
  'Alberta Provincial school. Authority: Bow Valley College. Code: 9995'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'f2c03ebb-983e-5575-9c3b-218efabe7d63',
  'Portage College - St. Paul Campus',
  '7297e54a-4de6-5c3c-9906-abfd6e1370c4',
  'free',
  'Alberta Provincial school. Authority: Portage College. Code: 0380'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '8d71ea1b-7391-59b2-bd71-da9ea7db6e0b',
  'Portage College-Cold Lake Campus',
  '7297e54a-4de6-5c3c-9906-abfd6e1370c4',
  'free',
  'Alberta Provincial school. Authority: Portage College. Code: 0381'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '398b29df-3259-544b-b863-c53711fe6ab0',
  'Portage College Lac La Biche',
  '7297e54a-4de6-5c3c-9906-abfd6e1370c4',
  'free',
  'Alberta Provincial school. Authority: Portage College. Code: 1898'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  '270672e4-350a-5b1e-9e04-e833c192d555',
  'Peace River Learning Centre',
  'b5cb76fe-398e-50b9-a3ff-b7bcdd186cc3',
  'free',
  'Alberta Provincial school. Authority: Northern Lakes College. Code: 0067'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO schools (id, name, division_id, tier, notes)
VALUES (
  'ac03e9a9-e5af-587e-832e-723a67c3a2cf',
  'Distance Learning High School',
  'b5cb76fe-398e-50b9-a3ff-b7bcdd186cc3',
  'free',
  'Alberta Provincial school. Authority: Northern Lakes College. Code: 1903'
) ON CONFLICT (id) DO NOTHING;