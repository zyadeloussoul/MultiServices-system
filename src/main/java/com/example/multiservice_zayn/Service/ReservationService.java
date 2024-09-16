package com.example.multiservice_zayn.Service;// ReservationService.java

import com.example.multiservice_zayn.Model.Reservation;
import com.example.multiservice_zayn.Repository.ReservationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReservationService {

    @Autowired
    private ReservationRepository reservationRepository;

    public Reservation createReservation(Reservation reservation) {
        return reservationRepository.save(reservation);
    }

    // Add more methods as needed (e.g., for fetching, updating, deleting reservations)
}
