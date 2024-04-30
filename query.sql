SELECT DISTINCT
    hc.id AS house_contract_id,
    tc.id AS tenant_contract_id,
    t.id AS tenant_id,
    t."firstName",
    t."lastName",
    t."phone",
    t."email"
FROM 
	"House" AS h
JOIN
    "HouseContract" AS hc ON h.id = hc."houseId"
JOIN
	"TenantContract" AS tc ON hc.id = tc."houseContractId"
JOIN
	"Tenant" AS t ON tc."tenantId" = t.id
JOIN
	"Service" AS s ON hc.id = s."houseContractId"
JOIN
	"MPxN" AS mpxn ON h.id = mpxn."houseId"
JOIN
	"Meter" AS m ON mpxn.id = m."mpxnId"
JOIN
	"TenantReading" AS tr ON m.id = tr."meterId"
WHERE
	hc."billingType" = 'BILL'
	AND hc."isPortfolio" = FALSE
	AND s."utilityStatus" = 'ACTIVE'
	AND m."utilityType" = 'electric'
	AND (m."isActive" = TRUE
	AND m."meterType" != 'SMART')
	OR (m."isActive" = FALSE
	AND m."meterType" = 'SMART')
	AND tr."meterReadingDate" < NOW() - INTERVAL '31 days'