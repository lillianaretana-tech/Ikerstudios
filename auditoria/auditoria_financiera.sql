-- Cartera 24 · Auditoría financiera de solo lectura · 2026-11-15
-- Devuelve una fila por control; cualquier incidencias > 0 requiere investigación.
WITH checks AS (
 SELECT 'pagos_sin_movimiento' control, count(*) incidencias FROM loans_payments p LEFT JOIN loans_cash_movements m ON m.payment_id=p.id AND m.movement_type='payment' WHERE m.id IS NULL
 UNION ALL SELECT 'movimientos_sin_pago',count(*) FROM loans_cash_movements m LEFT JOIN loans_payments p ON p.id=m.payment_id WHERE m.movement_type='payment' AND p.id IS NULL
 UNION ALL SELECT 'importe_pago_incorrecto',count(*) FROM loans_payments p JOIN loans_cash_movements m ON m.payment_id=p.id AND m.movement_type='payment' WHERE m.amount<>p.amount
 UNION ALL SELECT 'pago_ciclo_ajeno',count(*) FROM loans_payments p JOIN loans_cycles c ON c.id=p.cycle_id WHERE p.loan_id<>c.loan_id
 UNION ALL SELECT 'ciclos_duplicados',count(*) FROM (SELECT loan_id,cycle_number FROM loans_cycles GROUP BY 1,2 HAVING count(*)>1) t
 UNION ALL SELECT 'multiples_ciclos_activos',count(*) FROM (SELECT loan_id FROM loans_cycles WHERE status='active' GROUP BY 1 HAVING count(*)>1) t
 UNION ALL SELECT 'desembolsos_duplicados',count(*) FROM (SELECT loan_id FROM loans_cash_movements WHERE movement_type='loan_disbursement' GROUP BY 1 HAVING count(*)>1) t
 UNION ALL SELECT 'desembolso_importe_incorrecto',count(*) FROM loans_cash_movements m JOIN loans_loans l ON l.id=m.loan_id WHERE m.movement_type='loan_disbursement' AND m.amount<>-l.principal
 UNION ALL SELECT 'gastos_sin_movimiento',count(*) FROM loans_expenses e LEFT JOIN loans_cash_movements m ON m.expense_id=e.id AND m.movement_type='expense' WHERE m.id IS NULL
 UNION ALL SELECT 'movimientos_sin_gasto',count(*) FROM loans_cash_movements m LEFT JOIN loans_expenses e ON e.id=m.expense_id WHERE m.movement_type='expense' AND e.id IS NULL
 UNION ALL SELECT 'importe_gasto_incorrecto',count(*) FROM loans_expenses e JOIN loans_cash_movements m ON m.expense_id=e.id AND m.movement_type='expense' WHERE m.amount<>-e.amount
 UNION ALL SELECT 'referencias_sin_prestamo',count(*) FROM loans_disbursement_requests r LEFT JOIN loans_loans l ON l.id=r.loan_id WHERE l.id IS NULL
 UNION ALL SELECT 'prestamos_sin_cliente',count(*) FROM loans_loans l LEFT JOIN loans_clients c ON c.id=l.client_id WHERE c.id IS NULL
 UNION ALL SELECT 'activos_sin_cobrador',count(*) FROM loans_loans WHERE status IN ('active','refinanced') AND collector_id IS NULL
)
SELECT control,incidencias,CASE WHEN incidencias=0 THEN 'APROBADO' ELSE 'REVISAR' END estado FROM checks ORDER BY control;
