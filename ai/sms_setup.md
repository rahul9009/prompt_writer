# SMS (Text SMS) – RNDC Gateway Setup

मोबाइल वेरिफिकेशन के लिए SMS भेजने के लिए RNDC gateway (sms.rndcsoftware.com) use होता है।

---

## 1. API Endpoint

**URL:** `http://sms.rndcsoftware.com/rest/services/sendSMS/sendGroupSms`

**Method:** GET (query parameters)

---

## 2. Required Parameters

| Parameter    | Type     | Description |
|-------------|----------|-------------|
| AUTH_KEY *  | Alphanumeric | Login authentication key (unique per user) |
| message *   | Text     | SMS message content |
| senderId *  | Text     | Sender ID (max 6 characters) |
| routeId *   | Integer  | Route: 1 = Transactional, 2 = Promotional, 8 = OTP, etc. |
| mobileNos * | Text     | Mobile number(s), with or without country code; multiple comma-separated |
| smsContentType * | Text | `english` for English SMS, `unicode` for Unicode |

---

## 3. Optional Parameters (template/entity)

| Parameter         | Type   | Description |
|------------------|--------|-------------|
| entityid         | Numeric | PEID / Entity id (19 digit) |
| tmid             | Numeric | Telemarketer id |
| templateid        | Numeric | Template id registered for SMS content |
| concentFailoverId | Text   | As required by gateway |

---

## 4. Response

**Success:** `{"response":"RequestId","responseCode":"3001"}`

**Error example:** `{"response":"Token Not Found","responseCode":"3009"}`

Common response codes: 3001 = Success, 3002 = Invalid URL, 3009 = Authentication failed, 3011 = Insufficient Balance, etc. (full list in gateway docs.)

---

## 5. Environment Variables (.env)

```env
# SMS - RNDC
SMS_BASE_URL=http://sms.rndcsoftware.com/rest/services/sendSMS/sendGroupSms
SMS_AUTH_KEY=YourAuthKey
SMS_SENDER_ID=DEMOOS
SMS_ROUTE_ID=1
SMS_CONTENT_TYPE=english

# Optional (leave empty if not used)
SMS_ENTITY_ID=
SMS_TMID=
SMS_TEMPLATE_ID=
SMS_CONCENT_FAILOVER_ID=
```

- **SMS_AUTH_KEY:** RNDC से मिला authentication key। खाली रखने पर SMS नहीं भेजा जाएगा।
- **SMS_SENDER_ID:** 6 character से कम (e.g. DEMOOS).
- **SMS_ROUTE_ID:** 1 = Transactional (verification के लिए), 2 = Promotional, 8 = OTP Route, etc.
- **SMS_CONTENT_TYPE:** `english` या `unicode`.

---

## 6. Route IDs (reference)

| routeId | Description        |
|---------|--------------------|
| 1       | Transactional Route |
| 2       | Promotional Route   |
| 3       | Trans DND Route     |
| 7       | Transcrub Route    |
| 8       | OTP Route           |
| 9       | Trans Stock Route   |
| 10      | Trans Property Route |
| 11      | Trans DND Other Route |
| 12      | TransCrub Stock    |
| 13      | TransCrub Property |
| 14      | Short SMS           |
| 20      | Promotional Numeric |

Verification SMS के लिए आम तौर पर **1 (Transactional)** या **8 (OTP)** use करें।
