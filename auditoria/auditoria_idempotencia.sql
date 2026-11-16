-- Cartera 24: auditoría de idempotencia y referencias de operación. SOLO LECTURA.
SELECT
 (SELECT count(*) FROM public.loans_payment_requests) AS payment_requests,
 (SELECT count(*) FROM public.loans_disbursement_requests) AS disbursement_requests,
 (SELECT count(*) FROM public.loans_expenses WHERE request_id IS NOT NULL) AS expense_requests,
 (SELECT count(*) FROM public.loans_payment_requests r LEFT JOIN public.loans_payments p ON p.id=r.payment_id WHERE p.id IS NULL) AS orphan_payment_requests,
 (SELECT count(*) FROM public.loans_payment_requests r JOIN public.loans_payments p ON p.id=r.payment_id WHERE p.loan_id<>r.loan_id) AS wrong_payment_requests,
 (SELECT count(*) FROM public.loans_disbursement_requests r LEFT JOIN public.loans_cash_movements m ON m.loan_id=r.loan_id AND m.movement_type='loan_disbursement' WHERE m.id IS NULL) AS requests_without_disbursement,
 (SELECT count(*) FROM (SELECT payment_id FROM public.loans_cash_movements WHERE movement_type='payment' AND payment_id IS NOT NULL GROUP BY payment_id HAVING count(*)>1) t) AS duplicated_payment_movements,
 (SELECT count(*) FROM (SELECT expense_id FROM public.loans_cash_movements WHERE movement_type='expense' AND expense_id IS NOT NULL GROUP BY expense_id HAVING count(*)>1) t) AS duplicated_expense_movements;
