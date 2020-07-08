# Support of [TNAuthList identifier](https://tools.ietf.org/html/draft-ietf-acme-authority-token-tnauthlist-05) and [tkauth-01 challenge](https://tools.ietf.org/html/draft-ietf-acme-authority-token-04).


The support of TNAuthList identifier and tkauth-01 challenge allows a usage of acme.sh in an SP-KMS (Service Provider Key Management Server) role as specified in [ATIS-1000080](https://www.atis.org/sti-ga/resources/docs/ATIS-1000080.pdf).

acme.sh follows the call flows for SHAKEN certificate enrollment as defined in section 6.3.1 which are:
- STI-CA Account Creation.
- Service Provider Code token acquisition.
- Application for a Public Key Certificate.
- STI certificate acquisition 

To implement SPC token acquisition and STI certificate enrollment additional CLI parameters have been introduced:

```
  --tnauth TNAuthList               TNAuthList identifier
  --tnauthb64 TNAuthList            Base64 encoded TNAuthList identifier
  --spctoken spc-token              Service Provider Code Token
  --pa-hook                         Script to be executed to obtain the service provide code token needed for certificate enrollment
```

The parameters `--tnauth` and `--tnauthb64` exclude each other. If both parameters are specified the `--tnauth`  parameter will be used.

When using `--tnauth` either `--spectoken` or `--pa-hook` parameter must be specified. If `--spctoken` is missing the script defined in the `--pa-hook` parameter gets executed to obtain a new service provider code token.

`--tnauthb64` requires the specification of `--spctoken` option as this parameter will skip the service provider code token acquisition.

The `--pa-hook` script must be located in `.acme.sh/pa`. As of today, the following pa-hooks are available:

1. iconectiv.sh - handler to connect to iConectiv policy administrator
2. iconnect_stg.sh - handler to connect to iConectiv staging requirement 
3. stub.sh - test-handler

The iConectv handlers require user-id and password to authenticate towards to the iConectiv REST-API. These two parameters must be configured as environment variables before running `acme.sh`.

```
export PA_USER="<username>"
export PA_PASSWORD="<password>"
``` 

The below example polls the iConectiv staging environment to get an service provider code token and enrolls a STIR-SHAKEN certificate from an test-acme server.

```
acme.sh --server http://acme-srv.bar.local  --issue -d cert.stir.bar.local --tnauth 123456 --pa-hook iconectiv_stg.sh --standalone --debug 2  
```

The below example enrolls a STIR-SHAKEN certificate from a test-acme server. Tnauth identifier is already encoded; an service provider code token must be specified.

```
acme.sh --server http://acme-srv.bar.local  --issue -d cert.stir.bar.local --tnauthb64 d2hhdCBhIHNoaXQ= --spctoken 1234  --standalone --debug 2  
```

The below comoands:
- register an account at the Netnumber STI-Test-CA
- poll the IConectiv staging environment to get an SPC-token 
- enrolls a STIR-SHAKEN certificate from Netnumber

```
acme.sh --server https://testing-sti.netnumbercloud.com/sti-ca/acme --register-account --accountemail grindsa@foo.com --debug 2 --additional-header "AUTHORIZATION: Basic <token>" --accountkeylength ec-256
acme.sh --server https://testing-sti.netnumbercloud.com/sti-ca/acme  --issue -d foo.bar.local --tnauth <identifier> --standalone --output-insecure --ecc --pa-hook iconectiv_stg.sh  --additional-header "AUTHORIZATION: <token>"
```