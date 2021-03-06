--1.�������� ������� �����.
ALTER TABLE production 
ADD FOREIGN KEY (id_company) REFERENCES company (id_company);

ALTER TABLE production 
ADD FOREIGN KEY (id_medicine) REFERENCES medicine (id_medicine);

ALTER TABLE dealer 
ADD FOREIGN KEY (id_company) REFERENCES company (id_company);

ALTER TABLE [order]
ADD FOREIGN KEY (id_production) REFERENCES production (id_production);

ALTER TABLE [order]
ADD FOREIGN KEY (id_dealer) REFERENCES dealer (id_dealer);

ALTER TABLE [order]
ADD FOREIGN KEY (id_pharmacy) REFERENCES pharmacy (id_pharmacy);

--2 ������ ���������� �� ���� ������� ��������� ��������� �������� ������ � ��������� �������� �����, ���, ������ �������
SELECT pharmacy.name, [order].date, [order].quantity
FROM [order]
	LEFT JOIN pharmacy ON [order].id_pharmacy = pharmacy.id_pharmacy
    LEFT JOIN production ON [order].id_production = production.id_production
    LEFT JOIN company ON production.id_company = company.id_company
    LEFT JOIN medicine ON production.id_medicine = medicine.id_medicine
WHERE 
    medicine.name = '��������' AND 
    company.name = '�����'

--3 ���� ������ �������� �������� �������, �� ������� �� ���� ������� ������ �� 25 ������
SELECT medicine.id_medicine, medicine.name
FROM medicine
         LEFT JOIN production ON medicine.id_medicine = production.id_medicine
         LEFT JOIN company ON production.id_company = company.id_company
         LEFT JOIN "order" ON production.id_production = "order".id_production
WHERE
	company.name = '�����' AND
	production.id_production NOT IN(SELECT [order].id_production
									FROM [order]
									WHERE [order].date < '2019-01-25')
GROUP BY medicine.id_medicine, medicine.name;		


--4 ���� ����������� � ������������ ����� �������� ������ �����, ������� �������� �� ����� 120 �������
SELECT company.name, MIN(production.rating), MAX(production.rating)
FROM production
	INNER JOIN company ON production.id_company = company.id_company
	INNER JOIN [order] ON production.id_production = [order].id_production
GROUP BY company.id_company, company.name
HAVING COUNT([order].id_order) >= 120

-- 5. ���� ������ ��������� ������ ����� �� ���� ������� �������� "AstraZeneca" ���� � ������ ��� �������, � �������� ������ ���������� NULL.
SELECT dealer.id_dealer, pharmacy.name, dealer.name
FROM dealer
	LEFT JOIN company ON dealer.id_company = company.id_company
	LEFT JOIN [order] ON [order].id_dealer = dealer.id_dealer
	LEFT JOIN pharmacy ON pharmacy.id_pharmacy = [order].id_pharmacy
WHERE company.name = 'AstraZeneca'
ORDER BY dealer.id_dealer

--6. ��������� �� 20% ��������� ���� ��������, ���� ��� ��������� 3000, � ������������ ������� �� ����� 7 ����.
UPDATE production
SET price = price*0.8
WHERE production.id_production IN (
	SELECT production.id_production
	FROM production
		LEFT JOIN medicine ON production.id_medicine = medicine.id_medicine
	WHERE production.price > 3000 AND  medicine.cure_duration <= 7
)

-- 7. �������� ����������� �������.
--7 �������� ����������� �������
CREATE NONCLUSTERED INDEX [IX_dealer_id_company] ON [dbo].[dealer](
	[id_company] ASC
)

CREATE NONCLUSTERED INDEX [IX_production_id_company] ON [dbo].[production](
	[id_company] ASC
)

CREATE NONCLUSTERED INDEX [IX_production_id_medicine] ON [dbo].[production](
	[id_medicine] ASC
)
	
CREATE NONCLUSTERED INDEX [IX_order_id_production] ON [dbo].[order](
	[id_production] ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_dealer] ON [dbo].[order](
	[id_dealer] ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_pharmacy] ON [dbo].[order](
	[id_pharmacy] ASC
)

CREATE NONCLUSTERED INDEX [IX_order_date] ON [dbo].[order](
	[date] ASC
)

CREATE NONCLUSTERED INDEX [IX_production_rating] ON [dbo].[production](
	[rating] ASC
)

CREATE NONCLUSTERED INDEX [IX_company_name] ON [dbo].[company](
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_medicine_name] ON [dbo].[medicine](
	[name] ASC
)