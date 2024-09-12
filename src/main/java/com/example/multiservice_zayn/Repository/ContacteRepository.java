package com.example.multiservice_zayn.Repository;

import com.example.multiservice_zayn.Model.contacte;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ContacteRepository extends MongoRepository<contacte, String> {
}
