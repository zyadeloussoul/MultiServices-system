package com.example.multiservice_zayn.Repository;

import com.example.multiservice_zayn.Model.User;
import org.bson.types.ObjectId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import com.example.multiservice_zayn.Model.ServiceEntity;

import java.util.List;
import java.util.Optional;

@Repository
public interface ServiceRepo extends MongoRepository<ServiceEntity, ObjectId> {

    List<ServiceEntity> findByCategory(String category);
     ServiceEntity findByName(String name);
    List<ServiceEntity> findAll();

    Optional<ServiceEntity> findById(Long id);

    ServiceEntity save(ServiceEntity serviceEntity);

    boolean existsById(Long id);

    void deleteById(Long id);
}