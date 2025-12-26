-- Function to create a new tenant
CREATE OR REPLACE FUNCTION create_tenant(p_name VARCHAR(255))
    RETURNS UUID AS
$$
DECLARE
    v_tenant_id UUID;
BEGIN
    INSERT INTO tenants (name)
    VALUES (p_name)
    RETURNING id INTO v_tenant_id;

    RETURN v_tenant_id;
END;
$$ LANGUAGE plpgsql;
