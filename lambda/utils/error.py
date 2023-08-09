class MissingVariableError(Exception):
    """
    This exception is raised when a required environment
    variable is not set
    """

    def __init__(self, var, message="Environment variable not set"):
        self.var = var
        self.message = f"{message}: {self.var} "

        super().__init__(self.message)