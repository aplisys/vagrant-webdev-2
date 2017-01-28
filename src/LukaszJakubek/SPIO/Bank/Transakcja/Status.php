<?php
/**
 * Definicja statusów transakcji
 */

namespace LukaszJakubek\SPIO\Bank\Transakcja;

/**
 * Klasa definująca stałe status ponieważ php nie ma enum
 *
 * @author Lukasz Jakubek <lukasz.jakubek@aplisys.pl>
 */
final class Status
{
    /**
     * Nowa transakcjia
     */
    const FRESH = 'Nowa';

    /**
     * Transakcja przeprowadzona z powodzeniem
     */
    const EXECUTED = 'Wykonana';

    /**
     * Transakcja nieudana
     */
    const FAILED = 'Nieudana';
}
