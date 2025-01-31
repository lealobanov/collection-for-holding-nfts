import "NonFungibleToken"

access(all) contract Recipe {
    access(all) resource Collection: NonFungibleToken.Receiver {
        // Dictionary of NFT conforming tokens
        // NFT is a resource type with an UInt64 ID field
        access(all) var ownedNFTs: @{UInt64: {NonFungibleToken.NFT}}

        // Initialize the NFTs field to an empty collection
        init() {
            self.ownedNFTs <- {}
        }

        // Withdraw
        //
        // Function that removes an NFT from the collection 
        // and moves it to the calling context
        access(all) fun withdraw(withdrawID: UInt64): @{NonFungibleToken.NFT} {
            // If the NFT isn't found, the transaction panics and reverts
            let token <- self.ownedNFTs.remove(key: withdrawID)!
            return <-token
        }

        // Deposit
        //
        // Function that takes an NFT as an argument and 
        // adds it to the collection's dictionary
        access(all) fun deposit(token: @{NonFungibleToken.NFT}) {
            // Add the new token to the dictionary with a force assignment
            // If there is already a value at that key, it will fail and revert
            self.ownedNFTs[token.id] <-! token
        }

        // idExists checks to see if an NFT 
        // with the given ID exists in the collection
        access(all) fun idExists(id: UInt64): Bool {
            return self.ownedNFTs[id] != nil
        }

        // getIDs returns an array of the IDs that are in the collection
        access(all) fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        /// getSupportedNFTTypes returns a dictionary of supported NFT types
        /// and a boolean indicating if the type is supported
        access(all) view fun getSupportedNFTTypes(): {Type: Bool} {
            return {Type<@{NonFungibleToken.NFT}>(): true}
        }

        /// isSupportedNFTType checks if the given type is supported
        /// by the collection
        access(all) view fun isSupportedNFTType(type: Type): Bool {
            return type == Type<@{NonFungibleToken.NFT}>()
        }
    }
}