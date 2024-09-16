package com.example.multiservice_zayn.Repository;// ReservationRepository.java

import com.example.multiservice_zayn.Model.Reservation;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReservationRepository extends MongoRepository<Reservation, String> {
    // Custom query methods can be defined here if needed
}
