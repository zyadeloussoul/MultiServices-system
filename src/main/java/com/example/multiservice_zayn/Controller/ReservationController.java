package com.example.multiservice_zayn.Controller;// ReservationController.java

import com.example.multiservice_zayn.Model.Reservation;
import com.example.multiservice_zayn.Service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/reservations")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    @PostMapping
    public ResponseEntity<Reservation> createReservation(@RequestBody Reservation reservation) {
        Reservation createdReservation = reservationService.createReservation(reservation);
        return ResponseEntity.ok(createdReservation);
    }

    // Add more endpoints as needed (e.g., for fetching, updating, deleting reservations)
}
