-- Cartera 24: equivalencia de cartera asignada a Alex versus cartera del propietario.
-- Solo lectura. No cambia pagos, saldos ni estados.
WITH latest AS (
 SELECT DISTINCT ON (loan_id) loan_id,id,amount_due FROM public.loans_cycles ORDER BY loan_id,cycle_number DESC
), balances AS (
 SELECT l.id,l.status,l.collector_id,
 GREATEST(0,coalesce(c.amount_due,0)-coalesce((SELECT sum(p.amount) FROM public.loans_payments p WHERE p.cycle_id=c.id),0)) balance
 FROM public.loans_loans l LEFT JOIN latest c ON c.loan_id=l.id
), owner_view AS (
 SELECT id,balance FROM balances WHERE status IN ('active','refinanced') AND balance>0
), alex_view AS (
 SELECT id,balance FROM balances WHERE status IN ('active','refinanced') AND balance>0 AND collector_id='38b5b477-0619-42ab-8f88-b65390146352'::uuid
)
SELECT (SELECT count(*) FROM owner_view) owner_loans,
(SELECT count(*) FROM alex_view) alex_loans,
(SELECT coalesce(sum(balance),0) FROM owner_view) owner_total,
(SELECT coalesce(sum(balance),0) FROM alex_view) alex_total,
(SELECT count(*) FROM owner_view o FULL JOIN alex_view a USING(id) WHERE o.id IS NULL OR a.id IS NULL OR o.balance<>a.balance) differences;
