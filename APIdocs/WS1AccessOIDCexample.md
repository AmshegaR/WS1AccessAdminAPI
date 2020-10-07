
# VMware WorkSpace One Access (VIDM) OIDC Example

Swagger/Open API specification: <https://vdc-repo.vmware.com/raw.githubusercontent.com/vmware/idm/master/apidocs/swagger.json>
Docs: <https://github.com/vmware/idm/wiki/Integrating-Webapp-with-OAuth2>

## Application Catalog configuration

```json
{
  "uuid" : "e5d8c2c9-92f0-4c13-8389-9cb151a08578",
  "name" : "OpenID TestApp",
  "description" : null,
  "provisioningAdapter" : null,
  "icon" : null,
  "iconURL" : null,
  "packageVersion" : "1.0",
  "productVersion" : null,
  "authInfo" : {
    "type" : "AnyAppAuthInfo",
    "subType" : "oidcapptype",
    "values" : {
      "clientId" : [ "MyOIDCTester" ],
      "targetUrl" : [ "http://10.0.0.9:3000/" ]
    }
  },
  "iconHash" : null,
  "isMandatory" : false,
  "resourceConfiguration" : {
    "applicationAttributeMap" : null,
    "parameterValues" : { }
  },
  "isInternal" : false,
  "isVisibleInCatalog" : true,
  "resourceSyncProfileId" : null
}
```

## Remote App Access

**CLIENT INFORMATION**: `Client ID - MyOIDCTester`
*CLIENT CONFIGURATION*
**Redirect URI**: `http://10.0.0.9:3000`
**Token Type**: `Bearer`
**Grant Types**: `Authorization Code, Refresh Token`
*User GrantClient is given automatic access (users are not prompted)*
*Access Token Time-To-Live (TTL)3 hour(s)*
*Refresh Token Time-To-Live (TTL)3 month(s) (1 month is 30 days)*
*Idle Token Time-to-Live (TTL)4 day(s)*
**Scope**: `email profile user openid`

## OIDC Discovery

**GET**: <https://m646484007.vmwareidentity.de/SAAS/auth/.well-known/openid-configuration>

```json
{
 issuer: "https://m646484007.vmwareidentity.de/SAAS/auth",
 authorization_endpoint: "https://m646484007.vmwareidentity.de/acs/authorize",
 token_endpoint: "https://m646484007.vmwareidentity.de/acs/token",
 jwks_uri: "https://m646484007.vmwareidentity.de/SAAS/API/1.0/REST/auth/token?attribute=publicKey&format=jwks",
 subject_types_supported: [
  "public"
 ],
 response_types_supported: [
  "code",
  "id_token token",
  "id_token",
  "code token",
  "code id_token",
  "code id_token token"
 ],
  id_token_signing_alg_values_supported: [
  "RS256"
 ],
 token_endpoint_auth_methods_supported: [
  "client_secret_basic",
  "client_secret_post"
 ],
  userinfo_endpoint: "https://m646484007.vmwareidentity.de/acs/userinfo",
  claims_supported: [
   "iss",
   "sub",
   "subject",
   "aud",
   "auth_time",
   "nonce",
   "acr",
   "amr",
   "azp",
   "at_hash",
   "c_hash",
   "name",
   "given_name",
   "family_name",
   "middle_name",
   "nickname",
   "preferred_username",
   "profile",
   "picture",
   "website",
   "email",
   "email_verified",
   "gender",
   "birthdate",
   "zoneinfo",
   "locale",
   "phone_number",
   "phone_number_verified",
   "customClaims",
   "updated_at",
   "supportedClaims"
 ],
 scopes_supported: [
  "openid",
  "user",
  "admin",
  "profile",
  "email"
 ]
}
```

## Request Authorization Code

**GET**: <https://m646484007.vmwareidentity.de/acs/authorize?>
**state**=`35db1520-cece-4f64-9e13-77968f99fd28&`
**response_type**=`code&`
**client_id**=`MyOIDCTester&`
**redirect_uri**=`http://10.0.0.9:3000&`
**scope**=`email profile user openid`

## Exchange Authorization Code for Access Token

**POST**: <https://m646484007.vmwareidentity.de/acs/token>
*Message Body:*
**grant_type**=`authorization_code&`
**code**=`MjgxMDFiZjMtZWQyMC00OWY0LTg5YzEtZjM1ZjM0N2ZiY2U0I1JCZXlzMFRDUUJqVkhnbklnblQ5&`
**client_id**=`MyOIDCTester&`
**redirect_uri**=`http://10.0.0.9:3000&`
**scope**=`email+profile+user+openid`

**Result**:
**access_token**: `eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJleHAiOjE2MDE3MjYyMjgsImlhdCI6MTYwMTcxNTQyOCwic3ViIjoiZmY0NThhZDItNmJiMy00MmNiLTlmOWMtY2EwNzE0Y2NiOTk1IiwiYXV0aF90aW1lIjoxNjAxNzE1NDAzLCJzY3AiOiJvcGVuaWQgcHJvZmlsZSB1c2VyIGVtYWlsIiwiZW1sIjoiZ3Jpc2hAbWFpbC5jb20iLCJjdHgiOiJbe1wibXRkXCI6XCJ1cm46dm13YXJlOm5hbWVzOmFjOmNsYXNzZXM6TG9jYWxQYXNzd29yZEF1dGhcIixcImlhdFwiOjE2MDE3MTU0MDMsXCJ0eXBcIjpcIjAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAxNFwiLFwiaWRtXCI6dHJ1ZX1dIiwiaXNzIjoiaHR0cHM6Ly9tNjQ2NDg0MDA3LnZtd2FyZWlkZW50aXR5LmRlL1NBQVMvYXV0aCIsInBpZCI6ImM5NzAzMTg3LTk2NDItNDc5My1iNDk1LTc2ZWE1MWNmZmQzYiIsInBybiI6ImdyaXNoQE02NDY0ODQwMDciLCJhdWQiOiJodHRwczovL202NDY0ODQwMDcudm13YXJlaWRlbnRpdHkuZGUvU0FBUy9hdXRoL29hdXRodG9rZW4iLCJ3aWQiOiIiLCJpZHAiOiIiLCJ1c2VyX2lkIjoiMzEwOTExMSIsImRvbWFpbiI6IlN5c3RlbSBEb21haW4iLCJwcm5fdHlwZSI6IlVTRVIiLCJqdGkiOiIwMDA2MzE3NC1kYzAwLTRhM2ItYjhmNy1lZjc2ZDBiOTE4YWYiLCJjaWQiOiJNeU9JRENUZXN0ZXIifQ.nnmXpRPGHvALkbdJNjIFrVLBOJylf_k_imW1QdB-0y4wv_E94wcaaPq7O6MfgN8WpvAW9uKwGrWDIpPeCwitX_KckV8l8mkPDyrKbZBErTV57voqhtp2YqgGP40yNZXDSU2Ak3iuC9lmIx-1nU3Gft84Bwkpq2d5J5r5kocvd14`
**refresh_token**: `NGYxNTg5ODAtY2E5NS00Njg2LWE3NGItOTljNTEyZDMyNDhmI0hKYXYwbGRzSFZXTWg0S01HMWlQY0JKWnZyZTJnaUY0b3hrdk8zVlpJRWJwUEtkS0tvZzNtamRVVk9ZQ1NDcHIjMTYwMTcxNTQyOA`
**id_token**: `eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjE1OTk2NDA1NzMifQ.eyJub25jZSI6Ijc0MDFiODk1LTM5NjMtNDhiOC1hN2FhLThkMTNiZDQ4NzI4YiIsImVtYWlsIjoiZ3Jpc2hAbWFpbC5jb20iLCJleHAiOjE2MDE3MjYyMjgsImlhdCI6MTYwMTcxNTQyOCwic3ViIjoiZ3Jpc2hATTY0NjQ4NDAwNyIsImlzcyI6Imh0dHBzOi8vbTY0NjQ4NDAwNy52bXdhcmVpZGVudGl0eS5kZS9TQUFTL2F1dGgiLCJhdWQiOlsiTXlPSURDVGVzdGVyIl0sImF1dGhfdGltZSI6MTYwMTcxNTQwMywiYXpwIjoiTXlPSURDVGVzdGVyIiwiYXRfaGFzaCI6Ik51QndjVWFUVnpXOUNuYTF6X2ljOUEiLCJjX2hhc2giOiIzS1pPQm45UnFDTzdsQ1YyWDhpUmVRIiwibmFtZSI6IkdyaXNoYSBLIiwiZ2l2ZW5fbmFtZSI6IkdyaXNoYSIsImZhbWlseV9uYW1lIjoiSyIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJ1cGRhdGVkX2F0IjoxNjAxMjk1Nzg1ODU3fQ.mFoV9g2DFrgxcdeEHT4O9Aulq6_IM7BBViPz4z1DJrbgVZv6Y62FQrhE1nO9gmk5lWWNTYrzHL7WLzQovS_vpdOv38n7sR4kd7KSg0ROGvnAiiaB3SVZ57kL1vpu1gAtYblFI6KZRqseZQ_mDkHMJNW2V_uFKU_6RBDHc8dG_so`

## Decode JWT access_token

```json
{
  "typ": "JWT",
  "alg": "RS256"
}

{
  "exp": 1601726228,
  "iat": 1601715428,
  "sub": "ff458ad2-6bb3-42cb-9f9c-ca0714ccb995",
  "auth_time": 1601715403,
  "scp": "openid profile user email",
  "eml": "grish@mail.com",
  "ctx": "[{\"mtd\":\"urn:vmware:names:ac:classes:LocalPasswordAuth\",\"iat\":1601715403,\"typ\":\"00000000-0000-0000-0000-000000000014\",\"idm\":true}]",
  "iss": "https://m646484007.vmwareidentity.de/SAAS/auth",
  "pid": "c9703187-9642-4793-b495-76ea51cffd3b",
  "prn": "grish@M646484007",
  "aud": "https://m646484007.vmwareidentity.de/SAAS/auth/oauthtoken",
  "wid": "",
  "idp": "",
  "user_id": "3109111",
  "domain": "System Domain",
  "prn_type": "USER",
  "jti": "00063174-dc00-4a3b-b8f7-ef76d0b918af",
  "cid": "MyOIDCTester"
}
```

## Decode JWT id_token

```json
{
  "typ": "JWT",
  "alg": "RS256",
  "kid": "1599640573"
}
{
  "nonce": "7401b895-3963-48b8-a7aa-8d13bd48728b",
  "email": "grish@mail.com",
  "exp": 1601726228,
  "iat": 1601715428,
  "sub": "grish@M646484007",
  "iss": "https://m646484007.vmwareidentity.de/SAAS/auth",
  "aud": [
    "MyOIDCTester"
  ],
  "auth_time": 1601715403,
  "azp": "MyOIDCTester",
  "at_hash": "NuBwcUaTVzW9Cna1z_ic9A",
  "c_hash": "3KZOBn9RqCO7lCV2X8iReQ",
  "name": "Grisha K",
  "given_name": "Grisha",
  "family_name": "K",
  "email_verified": true,
  "updated_at": 1601295785857
}
```

## Validate Access Token

**GET**: <https://m646484007.vmwareidentity.de/SAAS/API/1.0/REST/auth/token?attribute=isValid>
**Authorization**: `Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJleHAiOjE2MDE3MjYyMjgsImlhdCI6MTYwMTcxNTQyOCwic3ViIjoiZmY0NThhZDItNmJiMy00MmNiLTlmOWMtY2EwNzE0Y2NiOTk1IiwiYXV0aF90aW1lIjoxNjAxNzE1NDAzLCJzY3AiOiJvcGVuaWQgcHJvZmlsZSB1c2VyIGVtYWlsIiwiZW1sIjoiZ3Jpc2hAbWFpbC5jb20iLCJjdHgiOiJbe1wibXRkXCI6XCJ1cm46dm13YXJlOm5hbWVzOmFjOmNsYXNzZXM6TG9jYWxQYXNzd29yZEF1dGhcIixcImlhdFwiOjE2MDE3MTU0MDMsXCJ0eXBcIjpcIjAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAxNFwiLFwiaWRtXCI6dHJ1ZX1dIiwiaXNzIjoiaHR0cHM6Ly9tNjQ2NDg0MDA3LnZtd2FyZWlkZW50aXR5LmRlL1NBQVMvYXV0aCIsInBpZCI6ImM5NzAzMTg3LTk2NDItNDc5My1iNDk1LTc2ZWE1MWNmZmQzYiIsInBybiI6ImdyaXNoQE02NDY0ODQwMDciLCJhdWQiOiJodHRwczovL202NDY0ODQwMDcudm13YXJlaWRlbnRpdHkuZGUvU0FBUy9hdXRoL29hdXRodG9rZW4iLCJ3aWQiOiIiLCJpZHAiOiIiLCJ1c2VyX2lkIjoiMzEwOTExMSIsImRvbWFpbiI6IlN5c3RlbSBEb21haW4iLCJwcm5fdHlwZSI6IlVTRVIiLCJqdGkiOiIwMDA2MzE3NC1kYzAwLTRhM2ItYjhmNy1lZjc2ZDBiOTE4YWYiLCJjaWQiOiJNeU9JRENUZXN0ZXIifQ.nnmXpRPGHvALkbdJNjIFrVLBOJylf_k_imW1QdB-0y4wv_E94wcaaPq7O6MfgN8WpvAW9uKwGrWDIpPeCwitX_KckV8l8mkPDyrKbZBErTV57voqhtp2YqgGP40yNZXDSU2Ak3iuC9lmIx-1nU3Gft84Bwkpq2d5J5r5kocvd14`

**Result**: `"True"`

## Validate JWT signature

**Get**: `https://m646484007.vmwareidentity.de/SAAS/API/1.0/REST/auth/token?attribute=publicKey`

**Result**:

```json
{
 alg: "RSA",
 mod: "150993318294568976607072610364405049782559355607856173481636412464422977479463137110728530626905506460142327005869879200369310327573021383157746879304340270377802225945992207091989161387940992930448785511679807179287237206174136099524733053046743612585267035668169250021206418881631397746014167472882350868541",
 exp: "65537",
 kid: "1599640573"
}
```

## UserInfo Endpoint

**GET**: <https://m646484007.vmwareidentity.de/acs/userinfo>
**Authorization**=`Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJleHAiOjE2MDE3MjYyMjgsImlhdCI6MTYwMTcxNTQyOCwic3ViIjoiZmY0NThhZDItNmJiMy00MmNiLTlmOWMtY2EwNzE0Y2NiOTk1IiwiYXV0aF90aW1lIjoxNjAxNzE1NDAzLCJzY3AiOiJvcGVuaWQgcHJvZmlsZSB1c2VyIGVtYWlsIiwiZW1sIjoiZ3Jpc2hAbWFpbC5jb20iLCJjdHgiOiJbe1wibXRkXCI6XCJ1cm46dm13YXJlOm5hbWVzOmFjOmNsYXNzZXM6TG9jYWxQYXNzd29yZEF1dGhcIixcImlhdFwiOjE2MDE3MTU0MDMsXCJ0eXBcIjpcIjAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAxNFwiLFwiaWRtXCI6dHJ1ZX1dIiwiaXNzIjoiaHR0cHM6Ly9tNjQ2NDg0MDA3LnZtd2FyZWlkZW50aXR5LmRlL1NBQVMvYXV0aCIsInBpZCI6ImM5NzAzMTg3LTk2NDItNDc5My1iNDk1LTc2ZWE1MWNmZmQzYiIsInBybiI6ImdyaXNoQE02NDY0ODQwMDciLCJhdWQiOiJodHRwczovL202NDY0ODQwMDcudm13YXJlaWRlbnRpdHkuZGUvU0FBUy9hdXRoL29hdXRodG9rZW4iLCJ3aWQiOiIiLCJpZHAiOiIiLCJ1c2VyX2lkIjoiMzEwOTExMSIsImRvbWFpbiI6IlN5c3RlbSBEb21haW4iLCJwcm5fdHlwZSI6IlVTRVIiLCJqdGkiOiIwMDA2MzE3NC1kYzAwLTRhM2ItYjhmNy1lZjc2ZDBiOTE4YWYiLCJjaWQiOiJNeU9JRENUZXN0ZXIifQ.nnmXpRPGHvALkbdJNjIFrVLBOJylf_k_imW1QdB-0y4wv_E94wcaaPq7O6MfgN8WpvAW9uKwGrWDIpPeCwitX_KckV8l8mkPDyrKbZBErTV57voqhtp2YqgGP40yNZXDSU2Ak3iuC9lmIx-1nU3Gft84Bwkpq2d5J5r5kocvd14`

**Result**:  

```json
{
    "email": "grish@mail.com",
    "updated_at": 1601295785857,
    "sub": "grish@M646484007",
    "subject": "grish@M646484007",
    "name": "Grisha K",
    "given_name": "Grisha",
    "family_name": "K",
    "email_verified": true
}
```

## SCIM Logged-in User Info

**GET**: <https://m646484007.vmwareidentity.de/SAAS/jersey/manager/api/scim/Me>
**Authorization**=`Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJleHAiOjE2MDE3MjYyMjgsImlhdCI6MTYwMTcxNTQyOCwic3ViIjoiZmY0NThhZDItNmJiMy00MmNiLTlmOWMtY2EwNzE0Y2NiOTk1IiwiYXV0aF90aW1lIjoxNjAxNzE1NDAzLCJzY3AiOiJvcGVuaWQgcHJvZmlsZSB1c2VyIGVtYWlsIiwiZW1sIjoiZ3Jpc2hAbWFpbC5jb20iLCJjdHgiOiJbe1wibXRkXCI6XCJ1cm46dm13YXJlOm5hbWVzOmFjOmNsYXNzZXM6TG9jYWxQYXNzd29yZEF1dGhcIixcImlhdFwiOjE2MDE3MTU0MDMsXCJ0eXBcIjpcIjAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAxNFwiLFwiaWRtXCI6dHJ1ZX1dIiwiaXNzIjoiaHR0cHM6Ly9tNjQ2NDg0MDA3LnZtd2FyZWlkZW50aXR5LmRlL1NBQVMvYXV0aCIsInBpZCI6ImM5NzAzMTg3LTk2NDItNDc5My1iNDk1LTc2ZWE1MWNmZmQzYiIsInBybiI6ImdyaXNoQE02NDY0ODQwMDciLCJhdWQiOiJodHRwczovL202NDY0ODQwMDcudm13YXJlaWRlbnRpdHkuZGUvU0FBUy9hdXRoL29hdXRodG9rZW4iLCJ3aWQiOiIiLCJpZHAiOiIiLCJ1c2VyX2lkIjoiMzEwOTExMSIsImRvbWFpbiI6IlN5c3RlbSBEb21haW4iLCJwcm5fdHlwZSI6IlVTRVIiLCJqdGkiOiIwMDA2MzE3NC1kYzAwLTRhM2ItYjhmNy1lZjc2ZDBiOTE4YWYiLCJjaWQiOiJNeU9JRENUZXN0ZXIifQ.nnmXpRPGHvALkbdJNjIFrVLBOJylf_k_imW1QdB-0y4wv_E94wcaaPq7O6MfgN8WpvAW9uKwGrWDIpPeCwitX_KckV8l8mkPDyrKbZBErTV57voqhtp2YqgGP40yNZXDSU2Ak3iuC9lmIx-1nU3Gft84Bwkpq2d5J5r5kocvd14`

**Result**:

```json
{
    "schemas": [
        "urn:scim:schemas:core:1.0",
        "urn:scim:schemas:extension:workspace:1.0",
        "urn:scim:schemas:extension:enterprise:1.0",
        "urn:scim:schemas:extension:workspace:mfa:1.0"
    ],
    "active": true,
    "userName": "grish",
    "id": "ff458ad2-6bb3-42cb-9f9c-ca0714ccb995",
    "meta": {
        "created": "2020-09-28T11:51:15.120Z",
        "lastModified": "2020-09-28T12:23:05.857Z",
        "location": "https://m646484007.vmwareidentity.de/SAAS/jersey/manager/api/scim/Users/ff458ad2-6bb3-42cb-9f9c-ca0714ccb995",
        "version": "W/\"1601295785857\""
    },
    "name": {
        "givenName": "Grisha",
        "familyName": "K"
    },
    "emails": [
        {
            "value": "grish@mail.com"
        }
    ],
    "groups": [
        {
            "value": "5fd52741-097e-4597-a552-4933b4835f28",
            "type": "direct",
            "display": "ALL USERS"
        },
        {
            "value": "03840c42-a435-4607-a9c3-25ec11685ff8",
            "type": "direct",
            "display": "TestGRP"
        }
    ],
    "roles": [
        {
            "value": "121f12a2-26d5-4b4c-a9ad-c42d443b1c71",
            "display": "User"
        }
    ],
    "urn:scim:schemas:extension:workspace:1.0": {
        "internalUserType": "LOCAL",
        "userStatus": "1",
        "domain": "System Domain",
        "userStoreUuid": "a9566648-586a-4ad8-bb6b-ed55515c7406"
    }
}
```
