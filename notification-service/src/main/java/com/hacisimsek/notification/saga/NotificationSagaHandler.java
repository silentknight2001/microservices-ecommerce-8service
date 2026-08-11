package com.hacisimsek.notification.saga;

import com.hacisimsek.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class NotificationSagaHandler {

    private final NotificationService notificationService;

    @KafkaListener(topics = "order-events", groupId = "notification-service-group")
    public void handleOrderEvents(String message) {
        log.info("Received order event: {}", message);
    }

    @KafkaListener(topics = "payment-events", groupId = "notification-service-group")
    public void handlePaymentEvents(String message) {
        log.info("Received payment event: {}", message);
    }

    @KafkaListener(topics = "shipping-events", groupId = "notification-service-group")
    public void handleShippingEvents(String message) {
        log.info("Received shipping event: {}", message);
    }
}