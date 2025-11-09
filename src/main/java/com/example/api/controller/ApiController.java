package com.example.api.controller;

import java.time.Instant;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.api.record.TimeStampResponseRecord;

@RestController
public class ApiController {

    @GetMapping(produces = "application/json")
    public ResponseEntity<TimeStampResponseRecord> handle() {
        return ResponseEntity.ok(new TimeStampResponseRecord(Instant.now()));
    }
}
