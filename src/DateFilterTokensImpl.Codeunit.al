codeunit 50103 "Date Filter Tokens Impl"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Filter Tokens", 'OnResolveDateFilterToken', '', false, false)]
    local procedure OnResolveDateFilterToken(DateToken: Text; var FromDate: Date; var ToDate: Date; var Handled: Boolean)
    begin
        case UpperCase(DateToken) of
            'YESTERDAY', 'YD':
                begin
                    FromDate := CalcDate('-1D', Today);
                    ToDate := FromDate;
                    Handled := true;
                end;
            'TOMORROW', 'TO':
                begin
                    FromDate := CalcDate('-1D', Today);
                    ToDate := FromDate;
                    Handled := true;
                end;
            'THISMONTH', 'TM':
                begin
                    FromDate := CalcDate('CM - 1M + 1D', Today);
                    ToDate := CalcDate('CM', Today);
                    Handled := true;
                end;
            'PREVMONTH', 'PM':
                begin
                    FromDate := CalcDate('CM - 2M + 1D', Today);
                    ToDate := CalcDate('CM - 1M', Today);
                    Handled := true;
                end;
            'FISCALYEAR', 'FY':
                begin
                    FromDate := GetFiscalYear();
                    ToDate := CalcDate('+12M - 1D', FromDate);
                    Handled := true;
                end;
            'PREVFISCALYEAR', 'PFY':
                begin
                    FromDate := CalcDate('-1Y', GetFiscalYear());
                    ToDate := CalcDate('+12M - 1D', FromDate);
                    Handled := true;
                end;
            'NEXTFISCALYEAR', 'NFY':
                begin
                    FromDate := CalcDate('+1Y', GetFiscalYear());
                    ToDate := CalcDate('+12M - 1D', FromDate);
                    Handled := true;
                end;
        end;
    end;

    local procedure GetFiscalYear(): Date
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.Reset();
        AccountingPeriod.SetRange("New Fiscal Year", true);
        AccountingPeriod.SetRange(Closed, false);
        if AccountingPeriod.FindFirst() then
            exit(AccountingPeriod."Starting Date");
    end;
}