package api

import (
	"github.com/go-playground/validator/v10"
	"github.com/suresh/simple_bank/util"
)

// validCurrency is a custom validator function for Gin
var validCurrency validator.Func = func(fieldLevel validator.FieldLevel) bool {
	if currency, ok := fieldLevel.Field().Interface().(string); ok {
		return util.IsSupportedCurrency(currency)
	}
	return false
}
