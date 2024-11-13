import csv
import subprocess
import logging

def audit(config_file):
    """
    Audits the macOS configuration based on a CSV configuration file.
    It verifies if the current system settings match the recommended values.
    
    :param config_file: Path to the CSV file containing the configuration parameters to audit.
    """
    try:
        with open(config_file, mode='r') as file:
            reader = csv.DictReader(file)
            total_checks = 0
            compliant_checks = 0

            logging.info("Auditing macOS configuration...")

            # Loop through each row in the CSV file
            for row in reader:
                param_id = row["ID"]
                param_category = row["Category"]
                param_name = row["Name"]
                param_method = row["Method"]
                param_method_option = row["MethodOption"]
                param_registry_path = row["RegistryPath"]
                param_registry_item = row["RegistryItem"]
                get_command = row["GetCommand"]
                recommended_value = row["RecommendedValue"]
                operator = row["Operator"]

                logging.debug(f"-------------------------------------------")
                logging.debug(f"Checking parameter {param_id}: {param_name}")

                ###################################
                #         STATUS/AUDIT            #
                ###################################

                # Registry
                #
                if param_method == "Registry":
                    logging.debug(f"Registry method")
                    get_command="defaults "+param_method_option+" read "+param_registry_path+" "+param_registry_item

                # If there is no command to get the current value, skip the row
                if not get_command:
                    logging.debug(f"Skipping parameter {param_name} (ID: {param_id}) due to missing GetCommand.")
                    continue

                try:
                    # Execute the command to get the current system value
                    logging.debug("Running : " + get_command)
                    current_value = subprocess.getoutput(get_command).strip()
                    total_checks += 1

                    # Check conformity based on the operator (e.g., =, !=, etc.)
                    if compare_values(current_value, recommended_value, operator):
                        logging.info(f"[OK] {param_name} (ID: {param_id}): Compliant")
                        compliant_checks += 1
                    else:
                        logging.info(f"[NON-COMPLIANT] {param_name} (ID: {param_id})")
                        logging.info(f"    - Current value : {current_value}")
                        logging.info(f"    - Recommended value : {recommended_value}")

                    logging.debug(f"Executed command: {get_command}")
                    logging.debug(f"Current value: {current_value}")
                    logging.debug(f"Recommended value: {recommended_value}")

                except Exception as e:
                    logging.error(f"Error executing the command for {param_name} (ID: {param_id}): {str(e)}")

            # Audit summary
            compliance_rate = (compliant_checks / total_checks) * 100 if total_checks > 0 else 0
            logging.info(f"Audit Summary: {compliant_checks}/{total_checks} compliant checks")
            logging.info(f"Compliance rate: {compliance_rate:.2f}%")

    except FileNotFoundError:
        logging.error(f"Configuration file '{config_file}' not found.")
    except Exception as e:
        logging.error(f"Error reading the CSV file: {str(e)}")


def compare_values(current_value, recommended_value, operator):
    """
    Compares the current value with the recommended value using the specified operator.
    
    :param current_value: The current system value.
    :param recommended_value: The value recommended in the CSV.
    :param operator: The operator to use for comparison (e.g., =, !=, etc.)
    :return: True if the values meet the condition, False otherwise.
    """
    try:
        if operator == '=':
            return current_value == recommended_value
        elif operator == '!=':
            return current_value != recommended_value
        # Additional operators can be added as needed
        else:
            return False
    except Exception as e:
        logging.error(f"Error comparing values: {str(e)}")
        return False
