package com.hacisimsek.inventory.repository;

import com.hacisimsek.inventory.model.InventoryItem;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.Optional;

public interface InventoryRepository extends MongoRepository<InventoryItem, String> {
    Optional<InventoryItem> findByProductId(String productId);
}