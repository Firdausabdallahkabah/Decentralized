// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract DecentralizedIdentity {
    struct identity {
        string name;
        string email;
        string verificationDocument;
        bool isVerified;
        bool isRevoked;
        address owner;
    }
    mapping(address => identity) private identities;
    mapping(address => bool) private authorizedVerifiers;

    address public manager;

    // Modifiers
    modifier onlyManager() {
        require(msg.sender == manager, "Only the manager can perform this action");
        _;
    }
    modifier identityExists(address user) {
        require(bytes(identities[user].name).length > 0, "Identity does not exist for the user");
        _;
    }
    modifier onlyVerifier() {
        require(authorizedVerifiers[msg.sender], "You are not an authorized verifier");
        _;
    }

    // Events
    event IdentityRegistered(address indexed user, string name, string email);
    event IdentityVerified(address indexed user);
    event IdentityRevoked(address indexed user);
    event VerifierAdded(address indexed verifierAddress);
    event VerifierRevoked(address indexed verifierAddress, string reason);

    // Constructor
    constructor() {
        manager = msg.sender;
    }

    // Register a user's identity
    function registerIdentity(string memory _name, string memory _email, string memory _verificationDocument) public {
        require(bytes(_name).length > 0, "You must enter your first and last name");
        require(bytes(_email).length > 0, "You must enter your email");
        require(bytes(identities[msg.sender].name).length == 0, "You already have an account with us");

        identities[msg.sender] = identity({
            name: _name,
            email: _email,
            verificationDocument: _verificationDocument,
            isVerified: false,
            isRevoked: false,
            owner: msg.sender
        });

        emit IdentityRegistered(msg.sender, _name, _email);
    }

    // Verify a user's identity
    function verifyIdentity(address _user) public onlyVerifier identityExists(_user) {
        require(!identities[_user].isVerified, "Identity already verified");
        identities[_user].isVerified = true;

        emit IdentityVerified(_user);
    }

    // Revoke an identity
    function revokeIdentity(address _user) public onlyVerifier identityExists(_user) {
        require(!identities[_user].isRevoked, "Identity already revoked");
        identities[_user].isRevoked = true;

        emit IdentityRevoked(_user);
    }

    // Retrieve a user's identity
    function getIdentity(address _user)
        public
        view
        returns (string memory, string memory, string memory, bool, bool, address)
    {
        identity memory userIdentity = identities[_user];
        return (
            userIdentity.name,
            userIdentity.email,
            userIdentity.verificationDocument,
            userIdentity.isVerified,
            userIdentity.isRevoked,
            userIdentity.owner
        );
    }

    // Remove an authorized verifier
    function removeAuthorizedVerifier(address _verifier) public onlyManager {
        require(authorizedVerifiers[_verifier], "Verifier is not authorized");
        authorizedVerifiers[_verifier] = false;

        emit VerifierRevoked(_verifier, "Verifier removed from the list");
    }
}