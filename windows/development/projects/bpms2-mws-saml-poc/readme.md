# Project SAML for MWS Proof of Concept

This project present a showcase on how to set up SAML for MWS with a third party Identity Provider (IdP)

## References

- [Test SAML IdP on Docker Hub](https://hub.docker.com/r/kristophjunge/test-saml-idp/)
- [An Example for the above docker image](https://medium.com/disney-streaming/setup-a-single-sign-on-saml-test-environment-with-docker-and-nodejs-c53fc1a984c9)
- [Empower - Using Single Sign-On with SAML and a Third-Party Identity Provider](https://documentation.softwareag.com/webmethods/mywebmethods_server/mws10-5/10-5_MWSw/index.html#page/my-webmethods-server-webhelp%2Fco-saml_SSO_third_party_idp.html%23)


## Prerequisites

### MWS Prerequisites

1. MWS must be configured to use an SSL port
2. [Set the required properties in websso.properties file](https://documentation.softwareag.com/webmethods/mywebmethods_server/mws10-5/10-5_MWSw/index.html#page/my-webmethods-server-webhelp/ta-setting_properties_in_the_websso.properties_file.html#wwID0ESTLS)
3. Ensure MWS Trusts the IdP certificate
4. Check existence of files SPMetadata.xml and IDPMetadata.xml in _SoftwareAG_directory_\MWS\server\serverName\config directory
5. Register My WebMEthods Server as an SP with the external IdP

### Other configuration sheck points

- ensure JCE files are correct and up to date