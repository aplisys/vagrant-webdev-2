<?php
/**
 * Definicja interfejsu transakcji
 */

namespace LukaszJakubek\SPIO\Bank\Transakcja;

/**
 * Wykonuje transakcję na rachunkach
 *
 * @author Łukasz Jakubek <lukasz.jakubek@aplisys.pl>
 */
interface TransakcjaInterface
{
    /**
     * Wykonuje transakcę. Zwraca true w przypadku powodzenia.
     *
     * @return bool
     */
    public function execute();

    /**
     * Zwraca status transakcji
     *
     * @return string
     */
    public function getStatus();
}
