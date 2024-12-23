 Documentation for the Challenge

Challenge Overview
This smart contract enables decentralized identity management, allowing users to register their identity, while authorized verifiers can verify or revoke it.



Key Features
1. Identity Registration: 
   - Users can register their identity by providing name, email, and verificationDocument.
   - Emits an IdentityRegistered event.

2. Identity Verification: 
   - Only authorized verifiers can verify a user’s identity.
   - Emits an IdentityVerified event.

3. Identity Revocation: 
   - Authorized verifiers can revoke identities if needed.
   - Emits an IdentityRevoked event.

4. Verifier Management:
   - The contract manager can add or remove authorized verifiers.
   - Emits VerifierAdded and VerifierRemoved events.

5. Access Control:
   - Manager-only functions: Adding/removing verifiers.
   - Verifier-only functions: Verifying/revoking identities.
   - User-only access: Interacting with their own identity.

Access Control
- Manager: 
  - Can add or remove verifiers.
  - Access control enforced with onlyManager modifier.
- Verifier: 
  - Can verify or revoke identities.
  - Access control enforced with onlyVerifier modifier.
- Identity Owner: 
  - Can only interact with their own identity unless explicitly allowed.
  - Access control enforced with onlyIdentityOwner modifier.

Events
1. IdentityRegistered: Logs when a user registers an identity.
2. IdentityVerified: Logs when a verifier marks an identity as verified.
3. IdentityRevoked: Logs when a verifier revokes an identity.
4. VerifierAdded: Logs when a new verifier is authorized.
5. VerifierRemoved: Logs when a verifier is removed.

Test Cases
1. Register an identity as a user.
2. Add a verifier (manager action).
3. Verify a user’s identity (verifier action).
4. Revoke a user’s identity (verifier action).
5. Attempt unauthorized actions (e.g., a non-verifier trying to verify/revoke).
