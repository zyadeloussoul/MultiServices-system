package com.example.multiservice_zayn.Repository;

import com.example.multiservice_zayn.Model.adminEmploye;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface AdminRepo extends MongoRepository<adminEmploye, String> {
}
